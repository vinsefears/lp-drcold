# Fallback static server for machines without Node installed.
# Mirrors serve.mjs. Usage:  powershell -ExecutionPolicy Bypass -File serve.ps1
# Prefer `node serve.mjs` when Node.js is available.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$port = 3000

$types = @{
  '.html'='text/html; charset=utf-8'; '.css'='text/css; charset=utf-8'
  '.js'='text/javascript; charset=utf-8'; '.mjs'='text/javascript; charset=utf-8'
  '.json'='application/json; charset=utf-8'; '.svg'='image/svg+xml'
  '.png'='image/png'; '.jpg'='image/jpeg'; '.jpeg'='image/jpeg'
  '.webp'='image/webp'; '.avif'='image/avif'; '.ico'='image/x-icon'
  '.woff2'='font/woff2'; '.txt'='text/plain; charset=utf-8'
}

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Host "Serving $root at http://localhost:$port"

try {
  while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    $res = $ctx.Response
    try {
      $path = [System.Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath)
      if ($path.EndsWith('/')) { $path += 'index.html' }

      $file = Join-Path $root ($path.TrimStart('/').Replace('/', '\'))
      $full = [System.IO.Path]::GetFullPath($file)

      if (-not $full.StartsWith($root, [StringComparison]::OrdinalIgnoreCase)) {
        $res.StatusCode = 403
        $b = [Text.Encoding]::UTF8.GetBytes('Forbidden')
      }
      elseif (Test-Path -LiteralPath $full -PathType Leaf) {
        $res.StatusCode = 200
        $ext = [System.IO.Path]::GetExtension($full).ToLower()
        $res.ContentType = if ($types.ContainsKey($ext)) { $types[$ext] } else { 'application/octet-stream' }
        $res.Headers.Add('Cache-Control', 'no-cache')
        $b = [System.IO.File]::ReadAllBytes($full)
      }
      else {
        $res.StatusCode = 404
        $res.ContentType = 'text/html; charset=utf-8'
        $b = [Text.Encoding]::UTF8.GetBytes('<h1>404</h1>')
      }

      $res.ContentLength64 = $b.Length
      $res.OutputStream.Write($b, 0, $b.Length)
    }
    catch { $res.StatusCode = 500 }
    finally { $res.OutputStream.Close() }
  }
}
finally { $listener.Stop(); $listener.Close() }
