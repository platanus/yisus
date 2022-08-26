import { createApp } from 'vue';
import { VueQueryPlugin } from 'vue-query';
import './css/application.css';
import App from './components/app.vue';
import ProjectsList from './components/projects-list.vue';
import TimeReportsList from './components/time-reports-list.vue';

document.addEventListener('DOMContentLoaded', () => {
  const app = createApp({
    components: { App },
  });

  app.use(VueQueryPlugin);

  app.component('ProjectsList', ProjectsList);
  app.component('TimeReportsList', TimeReportsList);

  app.mount('#vue-app');

  return app;
});
