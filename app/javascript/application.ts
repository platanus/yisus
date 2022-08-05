import { createApp } from 'vue';
import './css/application.css';
import App from './components/app.vue';
import ProjectsList from './components/projects-list.vue';

document.addEventListener('DOMContentLoaded', () => {
  const app = createApp({
    components: { App },
  });

  app.component('ProjectsList', ProjectsList);

  app.mount('#vue-app');

  return app;
});
