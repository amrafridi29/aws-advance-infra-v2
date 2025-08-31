function handler(event) {
  var response = event.response;
  var headers = response.headers;

  // Security Headers
  headers["strict-transport-security"] = {
    value: "max-age=31536000; includeSubDomains; preload",
  };

  headers["x-content-type-options"] = {
    value: "nosniff",
  };

  headers["x-frame-options"] = {
    value: "SAMEORIGIN",
  };

  headers["x-xss-protection"] = {
    value: "1; mode=block",
  };

  headers["referrer-policy"] = {
    value: "strict-origin-when-cross-origin",
  };

  // Content Security Policy
  headers["content-security-policy"] = {
    value:
      "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' data:; connect-src 'self'; frame-ancestors 'self'; base-uri 'self'; form-action 'self'",
  };

  // Permissions Policy
  headers["permissions-policy"] = {
    value:
      "geolocation=(), microphone=(), camera=(), payment=(), usb=(), magnetometer=(), gyroscope=(), accelerometer=()",
  };

  // Cache Control for static assets
  var uri = event.request.uri;
  if (uri.match(/\.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$/)) {
    headers["cache-control"] = {
      value: "public, max-age=31536000, immutable",
    };
  } else if (uri.match(/\.(html|htm)$/)) {
    headers["cache-control"] = {
      value: "public, max-age=0, must-revalidate",
    };
  } else {
    headers["cache-control"] = {
      value: "public, max-age=3600",
    };
  }

  // Remove server information
  if (headers["server"]) {
    delete headers["server"];
  }

  if (headers["x-powered-by"]) {
    delete headers["x-powered-by"];
  }

  return response;
}
