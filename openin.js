(function () {
  // the list of available apps to send link to
  const apps = ctx.getApps();

  const url = ctx.url;
  const srcApp = ctx.getSourceApp();

  const workApps = ["/Applications/Slack.app"];

  const isGithub = url.hostname.endsWith("github.com");
  const isAWS = url.hostname.endsWith("aws.amazon.com");
  const isBabySubdomain = url.hostname.includes("babylist.");
  const isBabyPath = url.pathname.startsWith("babylist/");
  const isGoogleWorkAuth = url.searchParams.get("authuser").endsWith("@babylist.com");

  let isWork = false;

  if (workApps.includes(srcApp.path)) {
    isWork = true;
  }

  if (isBabySubdomain) {
    isWork = true;
  }

  if (isAWS) {
    isWork = true;
  }

  if (isGoogleWorkAuth) {
    isWork = true;
  }

  if (isGithub && isBabyPath) {
    isWork = true;
  }

  if (isWork) {
    apps.forEach(function (app) {
      app.visible = app.name == "Google Chrome (work)";
    });
  }
})();
