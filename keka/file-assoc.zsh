#!/bin/zsh
emulate -LR zsh

function () {
  print_info "Setting Keka file associations..."

  local args=()
  local utis=(
    "com.apple.bom-compressed-cpio"
    "com.apple.xip-archive"
    "com.facebook.zstandard-archive"
    "com.facebook.zstandard-tar-archive"
    "com.google.brotli-archive"
    "com.google.brotli-tar-archive"
    "com.microsoft.cab"
    "com.microsoft.cab-archive"
    "com.microsoft.msi-installer"
    "com.microsoft.wim-archive"
    "com.microsoft.windows-executable"
    "com.pkware.zip-archive"
    "com.rarlab.rar-archive"
    "com.redhat.bzip2-archive"
    "com.winace.ace-archive"
    "com.winzip.zipx-archive"
    "cx.c3.pax-archive"
    "org.7-zip.7-zip-archive"
    "org.bzip.bzip2-archive"
    "org.bzip.bzip2-tar-archive"
    "org.gnu.gnu-tar-archive"
    "org.gnu.gnu-zip-archive"
    "org.gnu.gnu-zip-tar-archive"
    "org.kolivas.lrzip-archive"
    "org.kolivas.lrzip-tar-archive"
    "org.tukaani.lzma-archive"
    "org.tukaani.tar-xz-archive"
    "org.tukaani.xz-archive"
    "org.tukaani.xz-tar-archive"
    "public.archive.lha"
    "public.brotli-archive"
    "public.brotli-tar-archive"
    "public.bzip-archive"
    "public.bzip2-archive"
    "public.cpio-archive"
    "public.lrzip-archive"
    "public.lrzip-tar-archive"
    "public.lzip-archive"
    "public.lzip-tar-archive"
    "public.lzma-archive"
    "public.lzop-archive"
    "public.lzop-tar-archive"
    "public.pax-archive"
    "public.tar-archive"
    "public.tar-bzip2-archive"
    "public.tar-xz-archive"
    "public.xz-archive"
    "public.zip-archive"
    "public.zip-archive.first-part"
  )
  local exts=(
    "bzip"
    "bzip2"
    "cbr"
    "cbz"
    "lzo"
    "msi"
    "tar-gz"
    "tb2"
    "tbzip"
    "tbzip2"
    "tgzip"
  )

  for u ("${utis[@]}") args+=("--uti $u")
  for e ("${exts[@]}") args+=("--ext $e")

  eval 'duti' ${(j: :)args} '--rebuild' 'com.aone.keka'
}
