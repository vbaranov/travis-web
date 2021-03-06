import Ember from 'ember';
import { service } from 'ember-decorators/service';
import { task } from 'ember-concurrency';
import { computed } from 'ember-decorators/object';

export default Ember.Component.extend({
  @service flashes: null,

  tagName: 'button',
  classNames: ['switch'],
  classNameBindings: ['active', 'key'],

  attributeBindings: ['aria-checked', 'role'],

  role: 'switch',

  @computed('active')
  'aria-checked'(active) {
    if (active) {
      return 'true';
    } else {
      return 'false';
    }
  },

  save: task(function* () {
    this.toggleProperty('active');

    try {
      yield this.get('repo').saveSetting(this.get('key'), this.get('active'));
    } catch (e) {
      this.get('flashes').error('There was an error while saving your settings. Please try again.');
    }
  }).drop(),

  click() {
    this.get('save').perform();
  }
});
