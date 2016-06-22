p1_url = ''
$("div#upload1").dropzone
  url: '/upload'
  success: (f, response)->
    $('div#upload1').hide()
    p1_url = response
    $('#wrapper1 .network').css('background-image', 'url("' + p1_url + '")')
    $('div#wrapper1').show()


clearPopUp1 = ->
  document.querySelector('#wrapper1 .saveButton').onclick = null;
  document.querySelector('#wrapper1 .cancelButton').onclick = null;
  document.querySelector('#wrapper1 .network-popUp').style.display = 'none';
saveData1 = (data, callback) ->
  data.id = document.querySelector('#wrapper1 .node-id').value;
  data.label = document.querySelector('#wrapper1 .node-label').value;
  clearPopUp1();
  callback(data);
cancelEdit1 = (callback) ->
  clearPopUp1();
  callback(null);

container1 = document.querySelector('#wrapper1 .network')
options1 =
  width: '800px'
  height: '600px'
  autoResize: false
  interaction:
    dragView: false
    zoomView: false
  manipulation:
    enabled: true
    initiallyActive: true
    addNode: (data, callback)->
      document.querySelector('#wrapper1 .operation').innerHTML = "Add Node";
      document.querySelector('#wrapper1 .node-id').value = data.id;
      document.querySelector('#wrapper1 .node-label').value = data.label;
      document.querySelector('#wrapper1 .saveButton').onclick = saveData1.bind(this, data, callback);
      document.querySelector('#wrapper1 .cancelButton').onclick = clearPopUp1.bind();
      document.querySelector('#wrapper1 .network-popUp').style.display = 'block';
    editNode: (data, callback) ->
      document.querySelector('#wrapper1 .operation').innerHTML = "Edit Node";
      document.querySelector('#wrapper1 .node-id').value = data.id;
      document.querySelector('#wrapper1 .node-label').value = data.label;
      document.querySelector('#wrapper1 .saveButton').onclick = saveData1.bind(this, data, callback);
      document.querySelector('#wrapper1 .cancelButton').onclick = cancelEdit1.bind(this, callback);
      document.querySelector('#wrapper1 .network-popUp').style.display = 'block';
    addEdge: false
    editEdge: true
    deleteNode: true
    deleteEdge: true
    controlNodeStyle: {}
  physics:
    enabled: false
  edges:
    smooth: false
    color:
      color: '#2B7CE9'
      highlight: '#2B7CE9'
      inherit: false
  nodes:
    shape: 'circle'

nodes1 = new vis.DataSet []
edges1 = new vis.DataSet []
data1 =
  nodes: nodes1
  edges: edges1
network1 = new vis.Network(container1, data1, options1);

$('#enter').on 'click', ->
  points = new Object()
  for i in nodes1.get()
    points[i.label] = [i.x, i.y]
  $.ajax
    url: '/walk'
    type: 'post'
    contentType: 'application/json'
    dataType: 'json'
    data: JSON.stringify
      points: points
      picture: p1_url
    success: (data)->
#      console.log(data)
      $('#wrapper1').hide()
      $('#enter').hide()
      url_b = data.url_b
      url_t = data.url_t
      url_c = data.url_c
      url_l = data.url_l
      url_r = data.url_r

      WIDTH = window.innerWidth
      HEIGHT = window.innerHeight

      scene = new THREE.Scene()

      camera = new THREE.PerspectiveCamera(45, WIDTH / HEIGHT, 1, 10000)
      camera.position.z = 2000
      scene.add(camera)

      #light = new THREE.PointLight(0xFFCCFF)
      #light.position.set(-100, 200, 100)
      #scene.add(light)

      ambientLight = new THREE.AmbientLight(0x000000);
      scene.add(ambientLight);


      renderer = new THREE.WebGLRenderer({antialias: true})

      renderer.setSize(WIDTH, HEIGHT)
      document.body.appendChild(renderer.domElement)

      render = ->
        renderer.render(scene, camera);

      controls = new THREE.TrackballControls(camera);
      controls.rotateSpeed = 1.0;
      controls.zoomSpeed = 1.2;
      controls.panSpeed = 0.8;
      controls.noZoom = false;
      controls.noPan = false;
      controls.staticMoving = true;
      controls.dynamicDampingFactor = 0.3;
      controls.keys = [65, 83, 68];
      controls.addEventListener('change', render);

      animate = ->
        requestAnimationFrame(animate);
        controls.update();
      animate()

      geometry = new THREE.BoxGeometry(300, 300, 3000);
      #material = new THREE.MeshBasicMaterial( { color: 0x00ff00 } );
      r_t = new THREE.TextureLoader().load(url_r)
      r_t.wrapS = THREE.RepeatWrapping;
      r_t.repeat.x = -1;
      l_t = new THREE.TextureLoader().load(url_l)
      l_t.wrapS = THREE.RepeatWrapping;
      l_t.repeat.x = -1;
      t_t = new THREE.TextureLoader().load(url_t)
      b_t = new THREE.TextureLoader().load(url_b)
      z_t = new THREE.TextureLoader().load(url_c)
      z_t.wrapS = THREE.RepeatWrapping;
      z_t.repeat.x = -1;
      materials = [
        new THREE.MeshBasicMaterial(
          map: r_t
          side: THREE.DoubleSide
        ),
        new THREE.MeshBasicMaterial(
          map: l_t
          side: THREE.DoubleSide
        ),
        new THREE.MeshBasicMaterial(
          map: t_t
          side: THREE.DoubleSide
        ),
        new THREE.MeshBasicMaterial(
          map: b_t
          side: THREE.DoubleSide
        ),
        new THREE.MeshBasicMaterial(
          color: 0x00ff00
          transparent: true
          opacity: 0
        ),
        new THREE.MeshBasicMaterial(
          map: z_t
          side: THREE.DoubleSide
        )
      ]
      #cube = new THREE.Mesh(geometry, new THREE.MultiMaterial(materials));
      cube = new THREE.Mesh(geometry, new THREE.MultiMaterial(materials));
      scene.add(cube);
      animate()
      render()

