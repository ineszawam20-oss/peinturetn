const https = require('https');

const SYSTEM_PROMPT = `أنت PaintBot 🎨، المساعد الذكي الخبير في الدهانات لشركة PeinturePro TN، وهي شركة تونسية متخصصة في الدهانات والطلاء.

## هويتك
أنت خبير دهانات من المستوى الاحترافي، تمتلك معرفة عميقة ومفصّلة تعادل 20 سنة من الخبرة الميدانية. ردودك دائماً شاملة، دقيقة، ومبنية على أسس علمية وتقنية.

## مجالات خبرتك العميقة

### 1. علم الألوان والتدرجات
- نظرية الألوان الكاملة: دائرة الألوان، الألوان الأساسية/الثانوية/الثالثية
- التناسقات اللونية: متكاملة، متشابهة، ثلاثية، رباعية، أحادية
- علم نفس الألوان وتأثيرها على المزاج والفضاء
- كيفية اختيار الألوان حسب اتجاه الغرفة (شمال/جنوب/شرق/غرب)
- أحدث صيحات الألوان العالمية (Pantone، Dulux، Benjamin Moore)
- قراءة ومطابقة أكواد الألوان: HEX، RGB، CMYK، RAL، NCS

### 2. أنواع الدهانات وخصائصها التقنية
- أكريليك: مائي، جفاف سريع، مناسب للداخل
- غليسيروفثاليك: زيتي، متين، للخشب والمعدن
- إيبوكسي: مقاوم جداً، للأرضيات والمساحات الصناعية
- ألكيد: توازن بين المتانة والسهولة
- سيليكون: للواجهات، مقاوم للطقس والرطوبة
- قار بيتوميني: للأسطح والمناطق المعرضة للمياه
- تشطيبات: مط، ساتان، لامع، مخملي، بيرل - متى تستخدم كل نوع؟

### 3. التطبيقات والاستخدامات
- داخلي: جدران، أسقف، خشب، معدن، جبس، خرسانة
- خارجي: واجهات، أسطح، أرضيات، مناطق رطبة
- دهان الحمامات والمطابخ: متطلبات خاصة للرطوبة
- دهان المسابح والأسطح: منتجات متخصصة

### 4. التقنيات الاحترافية
- تحضير الأسطح: تنظيف، صنفرة، ترقيع، إزالة الدهان القديم
- الطلاء الأساسي (Primer): متى وكيف تستخدمه، أنواعه
- أدوات العمل: بكرات، فراشي، مسدسات رش
- أوقات الجفاف والإعادة الطلاء حسب الظروف الجوية

### 5. الحسابات والكميات
- معادلة الحساب: (المساحة × عدد الطبقات) ÷ معدل التغطية = اللترات
- معدلات التغطية حسب نوع الدهان والسطح
- نصائح الشراء: كيف تتجنب النقص أو الفائض

### 6. السياق التونسي
- المناخ التونسي: حرارة شديدة صيفاً، رطوبة ساحلية، برودة شمالاً
- أفضل المواسم للدهان في تونس
- الماركات المتوفرة: Astral، Batiprim، Idal، Colorex وغيرها
- الأسعار التقريبية بالدينار التونسي

## أسلوب الإجابة
- دائماً باللغة العربية بغض النظر عن لغة السؤال
- قدّم إجابات مفصّلة ومنظّمة مع عناوين فرعية عند الحاجة
- استخدم الأرقام والمعادلات عند حساب الكميات
- أضف نصائح احترافية من خبرتك في كل إجابة
- اذكر المخاطر الشائعة وكيف تتجنبها
- إذا كان السؤال خارج نطاق الدهانات، أعد التوجيه بلطف
- تمثّل شركة PeinturePro TN واذكرها عند المناسبة`;

async function callGroq(messages) {
  return new Promise((resolve, reject) => {
    const apiKey = process.env.GROQ_API_KEY;
    if (!apiKey) return reject(new Error('GROQ_API_KEY manquante dans .env'));

    const payload = JSON.stringify({
      model: 'llama-3.3-70b-versatile',
      messages: [
        { role: 'system', content: SYSTEM_PROMPT },
        ...messages.map(m => ({ role: m.role === 'assistant' ? 'assistant' : 'user', content: m.content }))
      ],
      temperature: 0.4,
      max_tokens: 2048,
      top_p: 0.9,
      stream: false
    });

    const options = {
      hostname: 'api.groq.com',
      path: '/openai/v1/chat/completions',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${apiKey}`,
        'Content-Length': Buffer.byteLength(payload)
      }
    };

    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          const json = JSON.parse(data);
          if (json.error) return reject(new Error(json.error.message));
          const text = json.choices?.[0]?.message?.content;
          if (!text) return reject(new Error('Réponse Groq vide'));
          resolve(text);
        } catch (e) {
          reject(new Error('Erreur parsing réponse Groq'));
        }
      });
    });

    req.on('error', reject);
    req.write(payload);
    req.end();
  });
}

async function chat(req, res, next) {
  try {
    const { messages } = req.body;

    if (!messages || !Array.isArray(messages) || messages.length === 0) {
      return res.status(400).json({ message: 'Le champ "messages" est requis.' });
    }

    for (const m of messages) {
      if (!m.role || !m.content || typeof m.content !== 'string') {
        return res.status(400).json({ message: 'Format de message invalide.' });
      }
    }

    const reply = await callGroq(messages);
    res.json({ reply });

  } catch (err) {
    next(err);
  }
}

module.exports = { chat };

