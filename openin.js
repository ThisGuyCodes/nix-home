/**
 * @typedef {object} OpenContextApp
 * @property {String} name - the name of the app
 * @property {boolean} running - check if app is running
 * @property {String} bundleIdentifier - the bundle identifier of the app
 * @property {boolean} visible - you can get or set this property, this is where you can apply your logic, for the list of the apps, that you are getting from OpenIn, you can configure which one you want to see in the result list
 * @property {String} path - The file system path to the application.
 */

/**
 * @typedef {object} OpenContextModifiers
 * @property {boolean} shift - shift pressed
 * @property {boolean} option - option pressed
 * @property {boolean} command - command pressed
 */

/**
 * @typedef {object} OpenContextSourceApp
 * @property {String} path - the path of the application, that sent an open request
 */

/**
 * @typedef {object} SearchParams
 * @property {function(String, String)} append - append the search key value
 * @property {function(String)} delete - delete all query items with the name
 * @property {function(String): String} get - get the first value of the query with name
 * @property {function(String): String[]} getAll - get all values as array of the query with name
 * @property {function(String): boolean} has - check if the query has a key
 * @property {function(String, String)} set - set the name and value for the search
 * @property {function(): String[]} keys - get the array of all keys
 */

/**
 * @typedef {object} URL
 * @property {String} fragment - everything after #
 * @property {String} host - hostname and port
 * @property {String} hostname - just a domain, hostname
 * @property {String} href - string representation of full url
 * @property {String} username - username
 * @property {String} password - password
 * @property {String} pathname - the path
 * @property {String} port - port
 * @property {String} protocol - scheme
 * @property {String} search - query of the url
 * @property {SearchParams} searchParams - object to work on url query
 */

/**
 * @typedef {object} CTX
 * @property {URL} url - returns the URL object
 * @property {function(): OpenContextSourceApp} getSourceApp - returns OpenContextSourceApp object, that can tell you if OpenIn recognized the application where link was opened
 * @property {function(): OpenContextApp[]} getApps - returns the array of apps, where OpenIn logic already applied, but you can override it, array of OpenContextApp
 * @property {function(): boolean} isForPrinting - checks if file was requested to be opened for printing
 * @property {function(): OpenContextModifiers} getModifiers - returns OpenContextModifiers object, that can tell which modifiers are pressed when link or file was requested to be opened by user
 * @property {function(): boolean} isShareMenu - checks if the link was sent by the Share Menu Open in OpenIn
 * @property {function(): boolean} isHandoff - checks if the link was sent by the Handoff in OpenIn
 * @property {function(): String} getFocusHint - get focus hint configured with the System Settings Focus (empty string if none is configured)
 */

/**
 * @type {CTX}
 * @global
 */
var ctx;

(function () {
  // the list of available apps to send link to
  const apps = ctx.getApps();

  const url = ctx.url;
  const srcApp = ctx.getSourceApp();

  const workHostnames = ["mcp.atlassian.com"];
  const personalHostnames = ["mcp.linear.app"];

  const workApps = ["/Applications/Slack.app"];
  const personalApps = ["/Applications/Discord.app"];

  const isGithub = url.hostname.endsWith("github.com");
  const isAWS = url.hostname.endsWith("aws.amazon.com");
  const isBabySubdomain = url.hostname.includes("babylist.");
  const isBabyPath = url.pathname.startsWith("/babylist/");
  const isGoogleWorkAuth = url.searchParams.get("authuser")?.endsWith("@babylist.com");
  const isWorkHostname = workHostnames.includes(url.hostname);

  const isWorkApp = workApps.includes(srcApp.path);

  [].some();
  const isWork = [isWorkHostname, isWorkApp, isBabySubdomain, isAWS, isGoogleWorkAuth, isGithub && isBabyPath].some(
    (it) => it,
  );

  if (isWork) {
    apps.forEach(function (app) {
      app.visible = app.name == "Google Chrome (work)";
    });
    return;
  }

  const isPersonalHostname = personalHostnames.includes(url.hostname);
  const isPersonalApp = personalApps.includes(srcApp.path);

  const isPersonal = [isPersonalHostname, isPersonalApp].some((it) => it);

  if (isPersonal) {
    apps.forEach(function (app) {
      app.visible = app.name == "Google Chrome (personal)";
    });
    return;
  }
})();
