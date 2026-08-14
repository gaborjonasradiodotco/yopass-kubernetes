import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '30s', target: 30 },   // warm up
    { duration: '2m', target: 150 },   // this should make it scale up
    { duration: '30s', target: 0 },    // stop, then it scales down again
  ],
  thresholds: {
    http_req_failed: ['rate<0.05'],
  },
};

// the Job sets this, it is the yopass service on plain http
const BASE_URL = __ENV.BASE_URL || 'http://yopass';

const BASE64 = 'wy4ECQMI'.repeat(250);
const LINES = BASE64.match(/.{1,64}/g).join('\n');
const FAKE_PGP =
  '-----BEGIN PGP MESSAGE-----\n\n' + LINES + '\n=abcd\n-----END PGP MESSAGE-----';

export default function () {
  const payload = JSON.stringify({
    message: FAKE_PGP,
    expiration: 3600,
    one_time: false,
  });

  const params = {
     headers: {
       'Content-Type': 'application/json' 
      } 
    };

  const createRes = http.post(`${BASE_URL}/create/secret`, payload, params);
  check(createRes, { 'create ok': (r) => r.status === 200 });

  let id = null;
  try {
    id = JSON.parse(createRes.body).message;
  } catch (e) {
    // if it failed we just skip the get
  }

  if (id) {
    const getRes = http.get(`${BASE_URL}/secret/${id}`);
    check(getRes, { 'get ok': (r) => r.status === 200 || r.status === 404 });
  }

  sleep(0.1);
}
