import axios, { type AxiosRequestTransformer, type AxiosResponseTransformer } from 'axios';
import { camelizeKeys } from 'humps';
import decamelizeKeys from '../utils/decamelizer';

const CSRFToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') || false;

const api = axios.create({
  headers: {
    'Content-Type': 'application/json',
    'X-CSRF-Token': CSRFToken,
  },
  transformRequest: [
    data => decamelizeKeys(data),
    ...(axios.defaults.transformRequest as AxiosRequestTransformer[]),
  ],
  transformResponse: [
    ...(axios.defaults.transformResponse as AxiosResponseTransformer[]),
    data => camelizeKeys(data),
  ],
});

export default api;
