document.addEventListener "deviceready", ->

  openElement = document.getElementById("openLayer")
  popElement = document.getElementById("popLayer")
  openModalElement = document.getElementById("openModal")

  if openElement?
    openElement.addEventListener "touchstart", ->
      layer = new Steroids.Layer({location: "http://localhost:13101/views/layers/show.html"})
      Steroids.layers.push layer

  if popElement?
    popElement.addEventListener "touchstart", ->
      Steroids.layers.pop()

  if openModalElement?
    openModalElement.addEventListener "touchstart", ->

      layer = new Steroids.Layer({location: "http://www.google.com"})

      Steroids.Modal.show(layer)

      setTimeout(()->
        Steroids.Modal.hide()
      , 5000)