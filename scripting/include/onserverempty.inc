/**
 * Called when a player disconnects and the total valid client count is 0.
 * @noreturn
 */
forward void OnServerEmpty();

/**
 * Called when the valid client count stops being 0.
 * @noreturn
 */
forward void OnServerNotEmpty();