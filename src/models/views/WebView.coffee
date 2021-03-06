class WebView

  params: {}
  id: null
  location: null
  allowedRotations: null

  navigationBar: new NavigationBar
  bounceShadow: new BounceShadow

  constructor: (options={})->
    @location = if options.constructor.name == "String"
      options
    else
      options.location

    if @location.indexOf("://") == -1 # if a path
      if window.location.href.indexOf("file://") == -1 # if not currently on file protocol
        @location = "#{window.location.protocol}//#{window.location.host}/#{@location}"

    @params = @getParams()
    @setAllowedRotations([])


  preload: (options={}, callbacks={}) ->
    steroids.debug "preload called for WebView #{JSON.stringify @}"

    proposedId = options.id || @location

    setIdOnSuccess = () =>
      steroids.debug "preload success: setting id"
      @id = proposedId

    steroids.nativeBridge.nativeCall
      method: "preloadLayer"
      parameters:
        id: proposedId
        url: options.location || @location
      successCallbacks: [setIdOnSuccess, callbacks.onSuccess]
      failureCallbacks: [callbacks.onFailure]

  getParams: ()->
    params = {}
    pairStrings = @location.slice(@location.indexOf('?') + 1).split('&')
    for pairString in pairStrings
      pair = pairString.split '='
      params[pair[0]] = pair[1]
    return params

  removeLoading: (options={}, callbacks={}) ->

    steroids.nativeBridge.nativeCall
      method: "removeTransitionHelper"
      successCallbacks: [callbacks.onSuccess]
      failureCallbacks: [callbacks.onFailure]

  setAllowedRotations: (options={}, callbacks={}) ->
    @allowedRotations = if options.constructor.name == "Array"
      options
    else
      options.allowedRotations

    window.shouldRotateToOrientation = (orientation) =>
      return if orientation in @allowedRotations
        true
      else
        false

    callbacks.onSuccess?.call()

  setBackgroundColor: (options={}, callbacks={}) ->
    newColor = if options.constructor.name == "String"
      options
    else
      options.color

    steroids.nativeBridge.nativeCall
      method: "setWebViewBackgroundColor"
      parameters:
        color: newColor
      successCallbacks: [callbacks.onSuccess]
      failureCallbacks: [callbacks.onFailure]
