# LP Dr. Cold Ar Condicionado

Landing page de página única para tráfego pago (Meta Ads / Google Ads).
Instalação, manutenção e higienização de ar-condicionado — Curitiba e região.

## Estrutura

```
index.html              página inteira (HTML + CSS + JS, sem dependências)
images/
  logo_drcold.png       logo da empresa
  cliente-web.jpg       foto da seção "Sobre" (otimizada)
  tecnico-web.jpg       foto da seção "Como a Dr. Cold entrega" (otimizada)
  logos/                logos das marcas, prontos para web
  brands/               logos originais enviados pelo cliente
serve.mjs               servidor local (Node)
serve.ps1               servidor local (PowerShell, sem Node)
reference/              referência visual do projeto
```

## Rodar localmente

Com Node:

```bash
node serve.mjs
```

Sem Node (Windows):

```powershell
powershell -ExecutionPolicy Bypass -File serve.ps1
```

Abre em <http://localhost:3000>.

## Deploy — Cloudflare Pages

Conectar este repositório e usar:

- **Build command:** _(vazio)_
- **Build output directory:** `/`

Não há etapa de build: o site é estático.

## Antes de subir a campanha

1. **Tags de conversão.** No topo do `<head>` do `index.html` há um bloco comentado
   para GTM e Meta Pixel. Os cliques no WhatsApp já disparam
   `dataLayer.push({event:'whatsapp_click'})` e `fbq('track','Contact')`.
2. **WhatsApp.** O número fica na constante `PHONE`, no script do rodapé.
   Os parâmetros de campanha (`utm_*`, `gclid`, `fbclid`) são repassados
   automaticamente para a mensagem, o que permite atribuir cada lead.
