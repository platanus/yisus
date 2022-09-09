import api from './index';

export default {
  index(date: string) {
    const path = '/api/internal/time_reports';

    return api({
      method: 'get',
      url: path,
      params: {
        date,
      },
    });
  },
  create(date: string) {
    const path = '/api/internal/time_reports';

    return api({
      method: 'post',
      url: path,
      params: {
        date,
      },
    });
  },
};
