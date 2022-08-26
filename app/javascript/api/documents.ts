import api from './index';

export default {
  create({ timeReportId }: { timeReportId: number }) {
    const path = '/api/internal/documents';

    return api({
      method: 'post',
      url: path,
      data: {
        timeReportId,
      },
    });
  },
};
