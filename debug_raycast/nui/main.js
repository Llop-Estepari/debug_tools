window.addEventListener('message', (event) => {
  if (event.data.type === 'RAYCAST') {
    document.getElementById('raycast-hit').innerHTML = event.data.hit;
    document.getElementById('raycast-entityHit').innerHTML = event.data.entityHit;
    document.getElementById('raycast-entityType').innerHTML = event.data.entityType;
    document.getElementById('raycast-endCoords').innerHTML = event.data.endCoords;
    document.getElementById('raycast-surface').innerHTML = event.data.surface;
  }
  if (event.data.type === 'ENTITY-DATA') {
    document.getElementById('entity').className = event.data.visiblity ? '' : 'hidden';
    document.getElementById('entity-model').innerHTML = event.data.entityModel;
    document.getElementById('entity-health').innerHTML = event.data.entityHealth;
    document.getElementById('entity-rotation').innerHTML = event.data.entityRotation;

  }
})