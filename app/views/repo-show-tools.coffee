`import Ember from 'ember'`

View = Ember.View.extend
  templateName: 'repos/show/tools'

  repoBinding: 'controller.repo'
  buildBinding: 'controller.build'
  jobBinding: 'controller.job'
  tabBinding: 'controller.tab'
  currentUserBinding: 'controller.currentUser'
  slugBinding: 'controller.repo.slug'


  didInsertElement: ->
    self = this
    $('.menu a').on 'click', ->
      self.closeMenu()

  willRemoveElement: ->
    $('.menu a').off 'click'

  closeMenu: ->
    $('.menu').removeClass('display')

  actions:
    menu: ->
      @popupCloseAll()
      $('#tools .menu').toggleClass('display')
      return false

    regenerateKeyPopup: ->
      if @get('canRegenerateKey')
        @set('active', true)
        @closeMenu()
        @popup('regenerate-key-popup')
        return false

    regenerateKey: ->
      @popupCloseAll()

      (@get('repo.content') || @get('repo')).regenerateKey
        success: =>
          @popup('regeneration-success')
        error: ->
          Travis.lookup('controller:flash').loadFlashes([{ error: 'Travis encountered an error while trying to regenerate the key, please try again.'}])

  canRegenerateKey: (->
    @get('hasAdminPermission')
  ).property('hasAdminPermission')

  hasPermission: (->
    if permissions = @get('currentUser.permissions')
      permissions.contains parseInt(@get('repo.id'))
  ).property('currentUser.permissions.length', 'repo.id')

  hasPushPermission: (->
    if permissions = @get('currentUser.pushPermissions')
      permissions.contains parseInt(@get('repo.id'))
  ).property('currentUser.pushPermissions.length', 'repo.id')

  hasAdminPermission: (->
    if permissions = @get('currentUser.adminPermissions')
      permissions.contains parseInt(@get('repo.id'))
  ).property('currentUser.adminPermissions.length', 'repo.id')

  displayRegenerateKey: (->
    @get('canRegenerateKey')
  ).property('canRegenerateKey')

  displaySettingsLink: (->
    @get('hasPushPermission')
  ).property('hasPushPermission')

  displayStatusImages: (->
    @get('hasPermission')
  ).property('hasPermission')

`export default View`