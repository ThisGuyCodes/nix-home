(function () {
  // the list of available apps to send link to
  const apps = ctx.getApps();

  const url = ctx.url;

  if (url.hostname.includes("babylist.")) {
    apps.forEach(function (app) {
      app.visible = app.name == "Google Chrome (work)";
    });
    return;
  }

  if (url.hostname.endsWith("aws.amazon.com")) {
    apps.forEach(function (app) {
      app.visible = app.name == "Google Chrome (work)";
    });
    return;
  }

  if (url.hostname.endsWith("github.com") && url.pathname.startsWith("babylist/")) {
    apps.forEach(function (app) {
      app.visible = app.name == "Google Chrome (work)";
    });
    return;
  }

  if (ctx.getSourceApp().path.startsWith("/Applications/Slack.app")) {
    apps.forEach(function (app) {
      app.visible = app.name == "Google Chrome (work)";
    });
    return;
  }
})();
