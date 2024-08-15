<?php

/**
 * This is project's console commands configuration for Robo task runner.
 *
 * @see http://robo.li/
 */

use Robo\Tasks;

/**
 * Robo Tasks.
 */
class RoboFile extends Tasks {

  /**
   * Local site update.
   */
  public function localUpdate() {
    $this->say("local site update started");
    $collection = $this->collectionBuilder();
    $collection->taskExec('drush state:set system.maintenance_mode 1 -y')
      ->taskExec('drush cr -y')
      ->taskExec('drush updatedb -y')
      ->taskExec('drush cim -y')
      ->taskExec('drush cr -y')
      ->taskExec('drush state:set system.maintenance_mode 0 -y');
    $this->say("local site update completed");
    return $collection;
  }

  /**
   * Local site install.
   */
  public function localInstall() {
    $this->say("local site install started");
    $collection = $this->collectionBuilder();
    $collection->taskExec('drush si --account-name=admin --account-pass=admin --existing-config -y')
      ->taskExec('drush cim -y')
      ->taskExec('drush cr -y');
    $this->say("local site install completed");
    return $collection;
  }

  /**
   * Remote site update.
   */
  public function siteUpdate() {
    $this->say("remote site update started");
    $collection = $this->collectionBuilder();
    $collection->taskExec('while ! nc -w 2 -z $DRUPAL_MYSQL_HOST 3306; do sleep 1; done')
      ->taskExec('drush state:set system.maintenance_mode 1 -y')
      ->taskExec('drush cr -y')
      ->taskExec('drush updatedb -y')
      ->taskExec('drush cim -y')
      ->taskExec('drush cr -y')
      ->taskExec('drush fc:media-fresh')
      ->taskExec('drush state:set system.maintenance_mode 0 -y')
      ->taskExec('drush cr -y');
    $this->say("remote site update completed");
    return $collection;
  }

  /**
   * Remote site install.
   */
  public function siteInstall() {
    $this->say("remote site install started");
    $collection = $this->collectionBuilder();
    $collection->taskExec('while ! nc -w 2 -z $DRUPAL_MYSQL_HOST 3306; do sleep 1; done')
      ->taskExec('drush si minimal --account-name=admin --account-pass=SuperSecurePassword -y install_configure_form.enable_update_status_module=NULL install_configure_form.enable_update_status_emails=NULL -vvv')
      ->taskExec('drush cset system.site uuid 123456')
      ->taskExec('drush cim -y')
      ->taskExec('drush cim -y')
      ->taskExec('drush cr -y');
    $this->say("remote site install completed");
    return $collection;
  }

}
