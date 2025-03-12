String verifyUrl(String url) {
  if (url.startsWith("/files/")) {
    url = "https://api.omnyqr.com/omny-backend$url";
    // L'URL già inizia con "/files/", non fare nulla
  }

  return url;
}