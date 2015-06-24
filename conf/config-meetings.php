<?php
/**
 * Set to true to enable the plugin by default
 */
DEFINE('PLUGIN_SPREEDWEBRTC_USER_DEFAULT_ENABLE', false);

/**
 * Set to true to load the plugin on WebApp start up
 */
DEFINE('PLUGIN_SPREEDWEBRTC_AUTO_START', true);

/**
 * The domain name including port and scheme where the spreed server is addressed by the browser. Use empty string if all on one server.
 */
DEFINE('PLUGIN_SPREEDWEBRTC_SPREED_DOMAIN', '');

/** Full path or URL to Spreed WebRTC. */
DEFINE('PLUGIN_SPREEDWEBRTC_SPREED_URL', '/webmeetings/');

/**
 * The domain name including port and scheme where this webapp instance is addressed by the browser. Use empty string when all on one server.
 */
DEFINE('PLUGIN_SPREEDWEBRTC_WEBAPP_DOMAIN', '');

/**
 * The secret used to authenticate a Zarafa user. Should be the same as the value
 * of the sharedsecret_secret option in the webmeetings.cfg file of the spreed server
 */
DEFINE('PLUGIN_SPREEDWEBRTC_WEBMEETINGS_SHARED_SECRET', 'the-default-secret-do-not-keep-me');

/**
 * This is the TTL (time to live) in seconds after which the authentication
 * token will expire.
 */
DEFINE('PLUGIN_SPREEDWEBRTC_WEBMEETINGS_AUTHENTICATION_EXPIRES', 3600);

/**
 * Sets whether only authenticated users can use the spreed app. If set to true
 * only webapp users can access the spreed server
 */
DEFINE('PLUGIN_SPREEDWEBRTC_REQUIRE_AUTHENTICATION', true);

/**
 * Set to true to have console logging on the spreed server
 */
DEFINE('PLUGIN_SPREEDWEBRTC_DEBUG', true);

/**
 * The secret used to authenticate a Zarafa user against the zarafa-presence service. 
 * Should be the same as the value of the server_secret_key option in the presence.cfg file of zarafa-presence
 * 
 */
DEFINE('PLUGIN_SPREEDWEBRTC_PRESENCE_SHARED_SECRET', 'test');

/**
 * This is the TTL (time to live) in seconds after which the presence authentication
 * token will expire.
 */
DEFINE('PLUGIN_SPREEDWEBRTC_PRESENCE_AUTHENTICATION_EXPIRES', 300);

/**
 * Set true to use the Zarafa TURN service (requires credetials provided by Zarafa)
 */
DEFINE('PLUGIN_SPREEDWEBRTC_TURN_USE_ZARAFA_SERVICE', false);

/**
 * This is the URL to the Zarafa TURN server authentication server
 */
DEFINE('PLUGIN_SPREEDWEBRTC_TURN_AUTHENTICATION_URL', 'https://turnauth0.zarafa.com/turnserverauth/');

/**
 * This is your username for the Zarafa TURN server authentication server
 * (provided by Zarafa)
 */
DEFINE('PLUGIN_SPREEDWEBRTC_TURN_AUTHENTICATION_USER', 'get-your-user-from-zarafa');

/**
 * This is your password for the Zarafa TURN server authentication server
 * (provided by Zarafa)
 */
DEFINE('PLUGIN_SPREEDWEBRTC_TURN_AUTHENTICATION_PASSWORD', 'get-your-password-from-zarafa');

?>
