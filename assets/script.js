document.addEventListener('DOMContentLoaded', () => {
  const buttons = document.querySelectorAll('[data-tab]');
  const panels  = document.querySelectorAll('[data-panel]');

  buttons.forEach(btn => {
    btn.addEventListener('click', () => {
      buttons.forEach(b => b.classList.remove('tab-active'));
      panels.forEach(p => p.classList.add('hidden'));
      btn.classList.add('tab-active');
      document.querySelector(`[data-panel="${btn.dataset.tab}"]`).classList.remove('hidden');
    });
  });
});
