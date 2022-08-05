import { shallowMount } from '@vue/test-utils';
import App from './app.vue';

describe('App', () => {
  test('is a Vue instance', () => {
    const wrapper = shallowMount(App);
    expect(wrapper.vm).toBeTruthy();
  });
});
