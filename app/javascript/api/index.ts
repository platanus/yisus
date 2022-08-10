import axios, { type AxiosRequestTransformer, type AxiosResponseTransformer } from 'axios';
import { camelizeKeys } from 'humps';
import decamelizeKeys from '../utils/decamelizer';

const api = axios.create({
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
