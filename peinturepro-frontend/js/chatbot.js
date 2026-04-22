/**
 * PaintBot — Widget chatbot flottant PeinturePro TN
 * Version avec icônes Google Material Symbols (plus d'émojis)
 * Intégrer avec : <script src="/js/chatbot.js"></script> avant </body>
 */
(function () {
  'use strict';

  const API_URL = '/api/chat';
  let conversationHistory = [];
  let isOpen = false;

  // ───────────────────────────────────────────
  // STYLES (inclut Google Material Symbols)
  // ───────────────────────────────────────────
  const style = document.createElement('style');
  style.textContent = `
    /* Google Material Symbols (icônes) */
    @import url('https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0,1');

    #paintbot-btn {
      position: fixed;
      bottom: 28px;
      right: 28px;
      width: 58px;
      height: 58px;
      border-radius: 50%;
      background: linear-gradient(135deg, #C8441A, #E8A020);
      border: none;
      cursor: pointer;
      box-shadow: 0 4px 20px rgba(200,68,26,.45);
      display: flex;
      align-items: center;
      justify-content: center;
      z-index: 9998;
      transition: transform .2s, box-shadow .2s;
    }
    #paintbot-btn:hover {
      transform: scale(1.08);
      box-shadow: 0 6px 28px rgba(200,68,26,.55);
    }
    #paintbot-btn svg { pointer-events: none; }

    #paintbot-badge {
      position: absolute;
      top: -4px;
      right: -4px;
      width: 18px;
      height: 18px;
      background: #E8A020;
      border-radius: 50%;
      border: 2px solid #fff;
      display: none;
    }

    #paintbot-window {
      position: fixed;
      bottom: 100px;
      right: 28px;
      width: 360px;
      max-height: 520px;
      background: #fff;
      border-radius: 20px;
      box-shadow: 0 20px 60px rgba(26,1,8,.18);
      display: flex;
      flex-direction: column;
      z-index: 9999;
      overflow: hidden;
      transform: scale(.92) translateY(16px);
      opacity: 0;
      pointer-events: none;
      transition: transform .25s cubic-bezier(.34,1.56,.64,1), opacity .2s;
      font-family: 'DM Sans', 'Inter', sans-serif;
    }
    #paintbot-window.open {
      transform: scale(1) translateY(0);
      opacity: 1;
      pointer-events: all;
    }

    #paintbot-header {
      background: linear-gradient(135deg, #C8441A, #E8A020);
      padding: 14px 18px;
      display: flex;
      align-items: center;
      gap: 10px;
      color: #fff;
    }
    #paintbot-header .pb-avatar {
      width: 36px;
      height: 36px;
      border-radius: 50%;
      background: rgba(255,255,255,.25);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 22px;
      flex-shrink: 0;
    }
    .material-symbols-outlined {
      font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
      font-size: 22px;
    }
    #paintbot-header .pb-avatar .material-symbols-outlined {
      color: #fff;
    }
    #paintbot-header .pb-info { flex: 1; }
    #paintbot-header .pb-name { font-weight: 700; font-size: .95rem; }
    #paintbot-header .pb-status { font-size: .75rem; opacity: .85; display: flex; align-items: center; gap: 4px; }
    #paintbot-header .pb-dot { width: 7px; height: 7px; background: #4ade80; border-radius: 50%; }
    #paintbot-close {
      background: none;
      border: none;
      color: #fff;
      cursor: pointer;
      padding: 4px;
      border-radius: 6px;
      opacity: .8;
      transition: opacity .15s;
    }
    #paintbot-close:hover { opacity: 1; }

    #paintbot-messages {
      flex: 1;
      overflow-y: auto;
      padding: 16px;
      display: flex;
      flex-direction: column;
      gap: 10px;
      background: #FAF7F4;
      scroll-behavior: smooth;
    }
    #paintbot-messages::-webkit-scrollbar { width: 4px; }
    #paintbot-messages::-webkit-scrollbar-thumb { background: #E2D5CC; border-radius: 4px; }

    .pb-msg {
      max-width: 82%;
      padding: 10px 14px;
      border-radius: 16px;
      font-size: .875rem;
      line-height: 1.55;
      animation: pbFadeIn .2s ease;
    }
    @keyframes pbFadeIn { from { opacity:0; transform:translateY(6px); } to { opacity:1; transform:translateY(0); } }

    .pb-msg.bot {
      background: #fff;
      color: #2C1D10;
      border-radius: 16px 16px 16px 4px;
      box-shadow: 0 2px 8px rgba(26,1,8,.07);
      align-self: flex-start;
    }
    .pb-msg.user {
      background: linear-gradient(135deg, #C8441A, #E8A020);
      color: #fff;
      border-radius: 16px 16px 4px 16px;
      align-self: flex-end;
    }
    .pb-msg.typing {
      background: #fff;
      align-self: flex-start;
      box-shadow: 0 2px 8px rgba(26,1,8,.07);
      padding: 12px 16px;
    }
    .pb-dots { display: flex; gap: 5px; }
    .pb-dots span {
      width: 7px; height: 7px;
      background: #C8441A;
      border-radius: 50%;
      animation: pbDot 1.2s infinite ease-in-out;
    }
    .pb-dots span:nth-child(2) { animation-delay: .2s; }
    .pb-dots span:nth-child(3) { animation-delay: .4s; }
    @keyframes pbDot { 0%,80%,100% { transform:scale(.6); opacity:.4; } 40% { transform:scale(1); opacity:1; } }

    .pb-suggestions {
      display: flex;
      flex-wrap: wrap;
      gap: 6px;
      margin-top: 4px;
    }
    .pb-chip {
      background: #F0E8E3;
      color: #C8441A;
      border: 1px solid #E2D5CC;
      border-radius: 20px;
      padding: 5px 12px;
      font-size: .78rem;
      font-weight: 500;
      cursor: pointer;
      transition: background .15s, color .15s;
      white-space: nowrap;
      display: inline-flex;
      align-items: center;
      gap: 6px;
    }
    .pb-chip .material-symbols-outlined {
      font-size: 16px;
    }
    .pb-chip:hover { background: #C8441A; color: #fff; border-color: #C8441A; }
    .pb-chip:hover .material-symbols-outlined { color: #fff; }

    #paintbot-footer {
      padding: 12px 14px;
      background: #fff;
      border-top: 1px solid #E2D5CC;
      display: flex;
      gap: 8px;
      align-items: flex-end;
    }
    #paintbot-input {
      flex: 1;
      border: 1.5px solid #E2D5CC;
      border-radius: 12px;
      padding: 9px 13px;
      font-size: .875rem;
      font-family: inherit;
      color: #2C1D10;
      background: #FAF7F4;
      resize: none;
      outline: none;
      max-height: 90px;
      overflow-y: auto;
      transition: border-color .2s;
      line-height: 1.4;
    }
    #paintbot-input:focus { border-color: #C8441A; }
    #paintbot-input::placeholder { color: #7A6255; }

    #paintbot-send {
      width: 38px;
      height: 38px;
      border-radius: 10px;
      background: linear-gradient(135deg, #C8441A, #E8A020);
      border: none;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
      transition: opacity .2s, transform .15s;
    }
    #paintbot-send:hover { opacity: .9; transform: scale(1.05); }
    #paintbot-send:disabled { opacity: .4; cursor: not-allowed; transform: none; }

    #paintbot-powered {
      text-align: center;
      font-size: .7rem;
      color: #7A6255;
      padding: 4px 0 8px;
      background: #fff;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 4px;
    }

    @media (max-width: 420px) {
      #paintbot-window { width: calc(100vw - 24px); right: 12px; bottom: 90px; }
      #paintbot-btn { bottom: 20px; right: 16px; }
    }
  `;
  document.head.appendChild(style);

  // ───────────────────────────────────────────
  // HTML
  // ───────────────────────────────────────────
  const container = document.createElement('div');
  container.innerHTML = `
    <button id="paintbot-btn" aria-label="Ouvrir le chatbot PaintBot">
      <span id="paintbot-badge"></span>
      <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
      </svg>
    </button>

    <div id="paintbot-window" role="dialog" aria-label="PaintBot">
      <div id="paintbot-header">
        <div class="pb-avatar">
          <span class="material-symbols-outlined">palette</span>
        </div>
        <div class="pb-info">
          <div class="pb-name">PaintBot</div>
          <div class="pb-status"><span class="pb-dot"></span> Expert peinture & couleurs</div>
        </div>
        <button id="paintbot-close" aria-label="Fermer">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round">
            <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
          </svg>
        </button>
      </div>

      <div id="paintbot-messages"></div>

      <div id="paintbot-footer">
        <textarea id="paintbot-input" rows="1" placeholder="Posez votre question sur la peinture…" maxlength="500"></textarea>
        <button id="paintbot-send" aria-label="Envoyer">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/>
          </svg>
        </button>
      </div>
      <div id="paintbot-powered">
        <span class="material-symbols-outlined" style="font-size:12px">sparkle</span>
        Propulsé par Groq AI · PeinturePro TN
      </div>
    </div>
  `;
  document.body.appendChild(container);

  // ───────────────────────────────────────────
  // REFS
  // ───────────────────────────────────────────
  const btn      = document.getElementById('paintbot-btn');
  const win      = document.getElementById('paintbot-window');
  const closeBtn = document.getElementById('paintbot-close');
  const messages = document.getElementById('paintbot-messages');
  const input    = document.getElementById('paintbot-input');
  const sendBtn  = document.getElementById('paintbot-send');
  const badge    = document.getElementById('paintbot-badge');

  // ───────────────────────────────────────────
  // HELPERS
  // ───────────────────────────────────────────
  function scrollBottom() {
    messages.scrollTop = messages.scrollHeight;
  }

  function addMessage(text, role) {
    const div = document.createElement('div');
    div.className = `pb-msg ${role}`;
    // Markdown basique : **bold**, *italic*, listes
    div.innerHTML = text
      .replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')
      .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
      .replace(/\*(.*?)\*/g, '<em>$1</em>')
      .replace(/\n/g, '<br>');
    messages.appendChild(div);
    scrollBottom();
    return div;
  }

  function showTyping() {
    const div = document.createElement('div');
    div.className = 'pb-msg typing';
    div.id = 'pb-typing';
    div.innerHTML = '<div class="pb-dots"><span></span><span></span><span></span></div>';
    messages.appendChild(div);
    scrollBottom();
  }

  function hideTyping() {
    const t = document.getElementById('pb-typing');
    if (t) t.remove();
  }

  function showSuggestions(items) {
    const wrap = document.createElement('div');
    wrap.className = 'pb-suggestions';
    items.forEach(item => {
      const chip = document.createElement('button');
      chip.className = 'pb-chip';
      // On place l'icône Material + le texte (sans émoji)
      const iconSpan = document.createElement('span');
      iconSpan.className = 'material-symbols-outlined';
      iconSpan.textContent = item.icon;
      const textSpan = document.createTextNode(item.label);
      chip.appendChild(iconSpan);
      chip.appendChild(textSpan);
      chip.onclick = () => { wrap.remove(); sendMessage(item.label); };
      wrap.appendChild(chip);
    });
    messages.appendChild(wrap);
    scrollBottom();
  }

  function showWelcome() {
    addMessage('Bonjour ! Je suis **PaintBot**, votre expert peinture & couleurs chez **PeinturePro TN**. Comment puis-je vous aider aujourd\'hui ?', 'bot');
    showSuggestions([
      { icon: 'palette', label: 'Choisir une couleur' },
      { icon: 'brush', label: 'Types de peinture' },
      { icon: 'calculate', label: 'Calculer la quantité' },
      { icon: 'home', label: 'Conseils façade' }
    ]);
  }

  // ───────────────────────────────────────────
  // API CALL
  // ───────────────────────────────────────────
  async function sendMessage(text) {
    const userText = (text || input.value).trim();
    if (!userText) return;

    input.value = '';
    input.style.height = 'auto';
    sendBtn.disabled = true;

    addMessage(userText, 'user');
    conversationHistory.push({ role: 'user', content: userText });

    showTyping();

    try {
      const res = await fetch(API_URL, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ messages: conversationHistory })
      });

      const data = await res.json();
      hideTyping();

      if (!res.ok) throw new Error(data.message || 'Erreur serveur');

      const reply = data.reply;
      conversationHistory.push({ role: 'assistant', content: reply });
      addMessage(reply, 'bot');

    } catch (err) {
      hideTyping();
      addMessage('⚠️ Désolé, une erreur est survenue. Veuillez réessayer.', 'bot');
      conversationHistory.pop(); // retirer le dernier message user
    }

    sendBtn.disabled = false;
    input.focus();
  }

  // ───────────────────────────────────────────
  // EVENTS
  // ───────────────────────────────────────────
  btn.addEventListener('click', () => {
    isOpen = !isOpen;
    win.classList.toggle('open', isOpen);
    badge.style.display = 'none';
    if (isOpen && conversationHistory.length === 0) {
      showWelcome();
    }
    if (isOpen) setTimeout(() => input.focus(), 300);
  });

  closeBtn.addEventListener('click', () => {
    isOpen = false;
    win.classList.remove('open');
  });

  sendBtn.addEventListener('click', () => sendMessage());

  input.addEventListener('keydown', (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  });

  // Auto-resize textarea
  input.addEventListener('input', () => {
    input.style.height = 'auto';
    input.style.height = Math.min(input.scrollHeight, 90) + 'px';
  });

  // Notif badge après 3s si pas ouvert
  setTimeout(() => {
    if (!isOpen) badge.style.display = 'block';
  }, 3000);

})();