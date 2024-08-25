const healthEl = document.getElementById('health');
const armourEl = document.getElementById('armour');
const positionEl = document.getElementById('position');
const headingEl = document.getElementById('heading');
const speedEl = document.getElementById('speed');

window.addEventListener('message', (event) => {
  if (event.data.type === 'PLAYER-DATA') {
    healthEl.innerHTML = `Health: ${event.data.health}`;
    armourEl.innerHTML = `Armour: ${event.data.armour}`;
    positionEl.innerHTML = event.data.position;
    headingEl.innerHTML = `Heading: ${event.data.heading}`;
    speedEl.innerHTML = `Speed: ${event.data.speed}`;
  }
})