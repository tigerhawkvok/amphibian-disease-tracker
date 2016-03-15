<!DOCTYPE html>
<html>
  <head>
    <?php
$debug = false;

if($debug) {
    error_reporting(E_ALL);
    ini_set("display_errors", 1);
    error_log("Project Browser is running in debug mode!");
}

$print_login_state = false;
require_once("DB_CONFIG.php");
require_once(dirname(__FILE__)."/core/core.php");
require_once(dirname(__FILE__)."/admin/async_login_handler.php");
$db = new DBHelper($default_database,$default_sql_user,$default_sql_password, $sql_url,$default_table,$db_cols);

$as_include = true;
# The next include includes core, and DB_CONFIG, and sets up $db
# require_once(dirname(__FILE__)."/admin-api.php");


$pid = $db->sanitize($_GET["id"]);
$suffix = empty($pid) ? "Browser" : "#" . $pid;


$validProject = $db->isEntry($pid, "project_id", true);
$loginStatus = getLoginState();

       ?>
    <title>Project <?php echo $suffix ?></title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta charset="UTF-8"/>
    <meta name="theme-color" content="#445e14"/>
    <meta name="viewport" content="width=device-width, minimum-scale=1, initial-scale=1" />

    <link rel="stylesheet" type="text/css" media="screen" href="css/main.css"/>
    <link rel="stylesheet" type="text/css" href="bower_components/json-human/css/json.human.css" />
    <link href="https://fonts.googleapis.com/css?family=Droid+Sans:400,700|Droid+Sans+Mono|Roboto:400,100,300,500,700,100italic,300italic,400italic,500italic,700italic" rel='stylesheet' type='text/css'/>

    <link rel="icon" type="image/png" sizes="16x16" href="assets/favicon16.png" />
    <link rel="icon" type="image/png" sizes="32x32" href="assets/favicon32.png" />
    <link rel="icon" type="image/png" sizes="64x64" href="assets/favicon64.png" />
    <link rel="icon" type="image/png" sizes="128x128" href="assets/favicon128.png" />
    <link rel="icon" type="image/png" sizes="256x254" href="assets/favicon256.png" />
    <link rel="icon" type="image/png" sizes="512x512" href="assets/favicon512.png" />
    <link rel="icon" type="image/png" sizes="1024x1024" href="assets/favicon1024.png" />

    <script src="bower_components/webcomponentsjs/webcomponents-lite.min.js"></script>

    <link rel="import" href="bower_components/polymer/polymer.html"/>


    <link rel="import" href="bower_components/paper-toggle-button/paper-toggle-button.html"/>
    <link rel="import" href="bower_components/paper-checkbox/paper-checkbox.html"/>
    <link rel="import" href="bower_components/paper-toast/paper-toast.html"/>
    <link rel="import" href="bower_components/paper-input/paper-input.html"/>
    <link rel="import" href="bower_components/paper-spinner/paper-spinner.html"/>
    <link rel="import" href="bower_components/paper-slider/paper-slider.html"/>
    <link rel="import" href="bower_components/paper-menu/paper-menu.html"/>
    <link rel="import" href="bower_components/paper-card/paper-card.html"/>

    <link rel="import" href="bower_components/paper-dialog/paper-dialog.html"/>
    <link rel="import" href="bower_components/paper-radio-group/paper-radio-group.html"/>
    <link rel="import" href="bower_components/paper-radio-button/paper-radio-button.html"/>

    <link rel="import" href="bower_components/paper-dialog-scrollable/paper-dialog-scrollable.html"/>
    <link rel="import" href="bower_components/paper-button/paper-button.html"/>
    <link rel="import" href="bower_components/paper-icon-button/paper-icon-button.html"/>
    <link rel="import" href="bower_components/paper-fab/paper-fab.html"/>
    <link rel="import" href="bower_components/paper-item/paper-item.html"/>
    <link rel="import" href="bower_components/paper-material/paper-material.html"/>

    <link rel="import" href="bower_components/gold-email-input/gold-email-input.html"/>
    <link rel="import" href="bower_components/gold-phone-input/gold-phone-input.html"/>

    <link rel="import" href="bower_components/iron-form/iron-form.html"/>
    <link rel="import" href="bower_components/iron-autogrow-textarea/iron-autogrow-textarea.html"/>

    <link rel="import" href="bower_components/font-roboto/roboto.html"/>
    <link rel="import" href="bower_components/iron-icons/iron-icons.html"/>
    <link rel="import" href="bower_components/iron-icons/image-icons.html"/>
    <link rel="import" href="bower_components/iron-icons/social-icons.html"/>
    <link rel="import" href="bower_components/iron-icons/communication-icons.html"/>
    <link rel="import" href="bower_components/iron-icons/editor-icons.html"/>

    <link rel="import" href="bower_components/neon-animation/neon-animation.html"/>

    <link rel="import" href="bower_components/marked-element/marked-element.html"/>

    <link rel="import" href="bower_components/google-map/google-map.html"/>
    <link rel="import" href="bower_components/google-map/google-map-marker.html"/>
    <link rel="import" href="bower_components/google-map/google-map-poly.html"/>

    <link rel="import" href="polymer-elements/copyright-statement.html"/>
    <link rel="import" href="polymer-elements/glyphicon-social-icons.html"/>


    <script type="text/javascript">
      (function(){var p=[],w=window,d=document,e=f=0;p.push('ua='+encodeURIComponent(navigator.userAgent));e|=w.ActiveXObject?1:0;e|=w.opera?2:0;e|=w.chrome?4:0;
      e|='getBoxObjectFor' in d || 'mozInnerScreenX' in w?8:0;e|=('WebKitCSSMatrix' in w||'WebKitPoint' in w||'webkitStorageInfo' in w||'webkitURL' in w)?16:0;
      e|=(e&16&&({}.toString).toString().indexOf("\n")===-1)?32:0;p.push('e='+e);f|='sandbox' in d.createElement('iframe')?1:0;f|='WebSocket' in w?2:0;
      f|=w.Worker?4:0;f|=w.applicationCache?8:0;f|=w.history && history.pushState?16:0;f|=d.documentElement.webkitRequestFullScreen?32:0;f|='FileReader' in w?64:0;
      p.push('f='+f);p.push('r='+Math.random().toString(36).substring(7));p.push('w='+screen.width);p.push('h='+screen.height);var s=d.createElement('script');
      s.src='bower_components/whichbrowser/detect.php?' + p.join('&');d.getElementsByTagName('head')[0].appendChild(s);})();
      /*window.onerror = function(e) {
      console.warn("Error thrown: "+e);
      return true;
      }*/
    </script>
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAZvQMkfFkbqNStlgzNjw1VOWBASd74gq4"></script>
    <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
    <script type="text/javascript" src="bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="js/purl.min.js"></script>
    <script type="text/javascript" src="js/xmlToJSON.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.3/underscore-min.js"></script>
    <script type="text/javascript" src="js/jquery.cookie.min.js"></script>
    <script type="text/javascript" src="bower_components/js-base64/base64.min.js"></script>
    <script type="text/javascript" src="bower_components/picturefill/dist/picturefill.min.js"></script>
    <script type="text/javascript" src="bower_components/imagelightbox/dist/imagelightbox.min.js"></script>
    <script type="text/javascript" src="bower_components/JavaScript-MD5/js/md5.min.js"></script>
    <script type="text/javascript" src="bower_components/json-human/src/json.human.js"></script>
    <script type="text/javascript" src="bower_components/zeroclipboard/dist/ZeroClipboard.min.js"></script>
    <script type="text/javascript" src="js/c.min.js"></script>
    <script type="text/javascript" src="js/project.js"></script>
    <script type="text/javascript">
      // Initial script
    </script>
    <style is="custom-style">
      paper-toggle-button.red {
      --paper-toggle-button-checked-bar-color:  var(--paper-red-500);
      --paper-toggle-button-checked-button-color:  var(--paper-red-500);
      --paper-toggle-button-checked-ink-color: var(--paper-red-500);
      }
      paper-input[disabled], paper-input[readonly] {
      --paper-input-container-focus-color: var(--paper-orange-500);
      --paper-input-container-underline: var(--paper-grey-300);
      --paper-input-container-underline-disabled: var(--paper-grey-300);
      }
    </style>
  </head>
  <body class="container-fluid">
    <header id="header-bar" class="fixed-bar clearfix row">
      <p class="col-xs-12 login-status-bar text-right">
        <?php
           $user = $_COOKIE["amphibiandisease_fullname"];
           $test = $loginStatus["status"];
           if($test) {
           ?>
        Logged in as <?php echo $user; ?>
        <paper-icon-button icon="icons:dashboard" class="click" data-href="https://amphibiandisease.org/admin-page.html" data-toggle="tooltip" title="Administration Dashboard" data-placement="bottom"> </paper-icon-button>
        <paper-icon-button icon='icons:settings-applications' class='click' data-href="https://amphibiandisease.org/admin" data-toggle="tooltip" title="Account Settings" data-placement="bottom"></paper-icon-button>
        <?php
    } else {
        ?>
        <paper-icon-button icon="icons:exit-to-app" class="click" data-toggle="tooltip" title="Login" data-href="https://amphibiandisease.org/admin" data-placement="bottom"></paper-icon-button>
        <?php
    }
           if(!empty($pid)) {
           ?>
        <paper-icon-button icon="icons:language" class="click" data-toggle="tooltip" title="Project Browser" data-href="https://amphibiandisease.org/project.php" data-placement="bottom"> </paper-icon-button>
        <?php } ?>
        <paper-icon-button icon="icons:home" class="click" data-href="https://amphibiandisease.org/home.php" data-toggle="tooltip" title="Home" data-placement="bottom"></paper-icon-button>
      </p>
    </header>
    <main>
      <?php
         if(empty($pid)) {
         ?>
      <h1 id="title">Amphibian Disease Project Browser</h1>
      <section id="major-map" class="row">
          <?php
         $search = array(
             "public" => "", # Loose query
         );
         $cols = array(
             "project_id",
             "project_title",
             "public",
             "carto_id",
             "bounding_box_n",
             "bounding_box_e",
             "bounding_box_w",
             "bounding_box_s",
             "locality",
         );
         $list = $db->getQueryResults($search, $cols, "AND", true, true);
         $polyOpacity = "0.35";
         $superCoords = array();
         $averageLat = 0;
         $averageLng = 0;
         $polys = 0;
         $polyHtml = "";
         foreach($list as $project) {
             if( empty($project["project_id"]) || empty($project["locality"]) ) continue;
             if(boolstr($project["public"])) {
                 $polyColor = "#ff7800";
                 $carto = json_decode(deEscape($project["carto_id"]), true);
                 # Escaped or unescaped
                 $bpoly = empty($carto["bounding&#95;polygon"]) ? $carto["bounding_polygon"] : $carto["bounding&#95;polygon"];
                 # Depending on the type of data stored, it could be
                 # in paths or not
                 $coords = empty($bpoly["paths"]) ? $bpoly : $bpoly["paths"];
             } else {
                 $polyColor = "#9C27B0"; # See https://github.com/AmphibiaWeb/amphibian-disease-tracker/issues/64
                 $coords = array();
                 $coords[] = array( "lat" => $project["bounding_box_n"], "lng" => $project["bounding_box_w"]);
                 $coords[] = array( "lat" => $project["bounding_box_n"], "lng" => $project["bounding_box_e"]);
                 $coords[] = array( "lat" => $project["bounding_box_s"], "lng" => $project["bounding_box_e"]);
                 $coords[] = array( "lat" => $project["bounding_box_s"], "lng" => $project["bounding_box_w"]);
                 $coords[] = array( "lat" => $project["bounding_box_n"], "lng" => $project["bounding_box_w"]);
             }
             $superCoords[] = $coords;
             # If we don't do this by project first, the center is
             # weighted by boundry complication rather than number of
             # projects
             $polys++;
             $points = 0;
             $projAverageLat = 0;
             $projAverageLng = 0;
             # Need to enable both click-events and clickable
             $html = "<google-map-poly closed fill-color='$polyColor' fill-opacity='$polyOpacity' stroke-weight='1' click-events clickable geodesic data-project='".$project["project_id"]."'>";
             foreach($coords as $point) {
                 $points++;
                 $lat = $point["lat"];
                 $lng = $point["lng"];
                 $projAverageLat = $projAverageLat + $lat;
                 $projAverageLng = $projAverageLng + $lng;
                 $html .= "<google-map-point latitude='$lat' longitude='$lng'></google-map-point>";
             }
             $html .= "</google-map-poly>\n";
             $polyHtml .= $html;
             $projAverageLat = $projAverageLat / $points;
             $projAverageLng = $projAverageLng / $points;
             $averageLat = $averageLat + $projAverageLat;
             $averageLng = $averageLng + $projAverageLng;
         }
         $averageLat = $averageLat / $polys;
         $averageLng = $averageLng / $polys;
         ?>
        <google-map class="col-xs-10 col-md-8 center-block" id="community-map" latitude="<?php echo $averageLat; ?>" longitude="<?php echo $averageLng; ?>" zoom="2" disable-default-ui map-type="satellite" api-key="AIzaSyAZvQMkfFkbqNStlgzNjw1VOWBASd74gq4">
          <?php echo $polyHtml; ?>
        </google-map>
        <p class="text-center text-muted">Community Project Map</p>
        <script type="text/javascript">
          _adp.aggregateHulls = <?php echo json_encode($superCoords); ?>;
        </script>
      </section>
      <?php } else if (!$validProject){ ?>
      <h1 id="title">Invalid Project</h1>
      <?php } else {
          $search = array("project_id" => $pid);
          $result = $db->getQueryResults($search, "*", "AND", false, true);
          $project = $result[0];
            ?>
      <h1 id="title">
        <?php echo $project["project_title"]; ?>
      </h1>
      <?php } ?>
      <section id="main-body" class="row">
        <?php if(empty($pid)) {
          $search = array(
              "public" => "", # Loose query
          );
          $cols = array(
              "project_id",
              "project_title",
              "public",
              "author_data",
              "locality",
          );
          $list = $db->getQueryResults($search, $cols, "AND", true, true);
          $html = "";
          $i = 0;
          $count = sizeof($list);
          $max = 25;
          $page = isset($_REQUEST["page"]) ? intval($_REQUEST["page"]): 1;
          if($page > 1) {
              $multiplier = $page - 1;
              $skip = $multiplier * $max;
          } else {
              $skip = 0;
          }
          $originalMax = $max;
          if ( $skip > $count ) {
              $html = "<h4>Whoops! <small class='text-muted'>These aren't the droids you're looking for</small></h4><p>You requested a project count that doesn't exit yet. Check back in a few weeks ;-)</p>";
          } else {
              foreach($list as $k=>$project) {
                  if( empty($project["project_id"]) || empty($project["locality"]) ) continue;
                  if ($i < $skip) continue;
                  $i++;
                  if($i >= $max + $skip ) break;
                  $authorData = json_decode($project["author_data"], true);
                  $icon = boolstr($project["public"]) ? '<iron-icon icon="social:public"></iron-icon>':'<iron-icon icon="icons:lock"></iron-icon>';
                  $projectHtml = "<button class='btn btn-primary' data-href='https://amphibiandisease.org/project.php?id=".$project["project_id"]."' data-project='".$project["project_id"]."' data-toggle='tooltip' title='Project #".substr($project["project_id"],0,8)."...'>".$icon." ".$project["project_title"]."</button> by " . $authorData["name"] . " at " . $authorData["affiliation"];
                  $html .= "<li>".$projectHtml."</li>\n";
              }
              if ($i < $max) {
                  $count = $i;
                  $max = $i;
              }
              if ($skip > 0) {
                  $max = $skip . " &$8212; " . $max;
              }
              $html = '<ul id="project-list" class="col-xs-12 col-md-8 col-lg-6 hidden-xs project-list project-list-page">' . $html . '        </ul>';
          }
          # Build the paginator
          $pages = intval($count / $originalMax);
          $pages += $count % $orignalMax > 0 ? 1:0;
          $pages = 1;
          # https://getbootstrap.com/components/#pagination
          $olderDisabled = $page > 1 ? "":"disabled";
          $newerDisabled = $page * $originalMax <= $count ? "":"disabled";
          ?>
        <div class="col-xs-12 visible-xs-block text-right">
          <button id="toggle-project-viewport" class="btn btn-primary">Show Project List</button>
        </div>
        <h2 class="col-xs-12 status-notice hidden-xs project-list project-list-page">Showing <?php echo $max;?> newest projects <small class="text-muted">of <?php echo $count; ?></small></h2>

          <?php echo $html; ?>

        <div class="col-xs-12 col-md-4 col-lg-6 project-search project-list-page">
          <h3>Search Projects</h3>
          <div class="form-horizontal">
            <div class="search-project form-group">
              <label for="project-search" class="col-xs-12 col-md-5 col-lg-3 control-label">Search Projects</label>
              <div class="col-xs-12 col-md-7 col-lg-9">
                <input type="text" class="form-control" placeholder="Project ID or name..." name="project-search" id="project-search"/>
              </div>
            </div>
          </div>
          <paper-radio-group selected="names" id="search-filter">
            <paper-radio-button name="names" data-cols="project_id,project_title" data-cue="Project ID or name...">
              Project Names &amp; IDs
            </paper-radio-button>
            <paper-radio-button name="users" data-cols="author_data" data-cue="Name or email...">
              PIs, Labs, Creators, Affiliation
            </paper-radio-button>
            <paper-radio-button name="taxa" data-cols="sampled_species,sampled_clades" data-cue="Scientific name...">
              Project Taxa
            </paper-radio-button>
          </paper-radio-group>
          <ul id="project-result-container">

          </ul>
        </div>
        <nav class="col-xs-12 project-pagination center-block text-center" id="project-pagination">
          <ul class="pagination">
            <li class="<?php echo $olderDisabled; ?>">
              <a href="#"><span aria-hidden="true">&larr;</span> Older</a>
            </li>
            <?php
          $k = 1;
          while ( $k <= $pages ) {
              echo "<li><a href='?page=".$k."'>".$k."</a></li>\n";
              $k++;
          }
               ?>
            <li class="<?php echo $newerDisabled; ?>">
              <a href="#">Newer <span aria-hidden="true">&rarr;</span></a>
            </li>
          </ul>
        </nav>
        <?php } else if (!$validProject){ ?>
        <h2 class="col-xs-12">Project <code><?php echo $pid ?></code> doesn&#39;t exist.</h2>
        <p>Did you want to <a href="projects.php">browse our projects instead?</a></p>
        <?php } else { ?>
        <h2 class="col-xs-12"><span class="text-muted small">Project #<?php echo $pid; ?></small></h2>
        <h2 class="col-xs-12">
          Project Abstract
        </h2>
        <marked-element class="project-abstract col-xs-12 indent">
          <div class="markdown-html"></div>
          <script type="text/markdown"><?php echo deEscape($project["sample_notes"]); ?></script>
        </marked-element>

        <div class="col-xs-12 basics-list">
          <h2>Project Basics</h2>
          <?php
          $authorData = json_decode($project["author_data"], true);

             ?>
          <div class="row">
            <paper-input readonly label="ARK identifier" value="<?php echo $project["project_obj_id"]; ?>" class="col-xs-9 col-md-11 ark-identifier"></paper-input>
            <paper-fab icon="icons:content-copy" class="materialblue" id="copy-ark" data-ark="<?php echo $project["project_obj_id"]; ?>" data-clipboard-text="https://n2t.net/<?php echo $project["project_obj_id"]; ?>" data-toggle="tooltip" title="Copy Link"></paper-fab>
          </div>
          <paper-input readonly label="Project pathogen" value="<?php echo $project["disease"]; ?>"></paper-input>
          <paper-input readonly label="Project PI" value="<?php echo $project["pi_lab"]; ?>"></paper-input>
          <paper-input readonly label="DOI" value="<?php echo $project["publication"]; ?>"></paper-input>
          <paper-input readonly label="Project Contact" value="<?php echo $authorData["name"]; ?>"></paper-input>
          <paper-input readonly label="Diagnostic Lab" value="<?php echo $authorData["diagnostic_lab"]; ?>"></paper-input>
          <paper-input readonly label="Affiliation" value="<?php echo $authorData["affiliation"]; ?>"></paper-input>
          <div class="row" id="email-fill">
            <?php
               require_once("admin/CONFIG.php");
               ?>
            <script src="https://www.google.com/recaptcha/api.js" async defer></script>
            <p class="col-xs-12 col-md-3 col-lg-2 col-xl-1">
              Contact email:
              <br/>
              <span class="text-muted small">Please solve the CAPTCHA to see the contact email</span>
            </p>
            <div class="g-recaptcha col-xs-12 col-md-9 col-lg-10 col-xl-11" data-sitekey="<?php echo $recaptcha_public_key; ?>" data-callback="renderEmail"></div>
          </div>
        </div>
        <div class="needs-auth col-xs-12" id="auth-block">
<?php
   $limitedProject = array();
   $cleanCarto = deEscape($project["carto_id"]);
   $carto = json_decode($cleanCarto, true);
   $cartoLimited = array(
       "bounding_polygon" => array(
           "fillColor" => $carto["bounding_polygon"]["fillColor"],
           "fillOpacity" => $carto["bounding_polygon"]["fillOpacity"],
       ),
   );
   $limitedProjectCols = array(
       "public",
       "bounding_box_n",
       "bounding_box_e",
       "bounding_box_w",
       "bounding_box_s",
       "lat",
       "lng",
   );
   foreach($limitedProjectCols as $col) {
       $limitedProject[$col] = $project[$col];
   }
   $limitedProject["carto_id"] = $cartoLimited;
   $jsonDataLimited = json_encode($limitedProject);
   $jsonData = json_encode($project);

if(boolstr($project["public"]) === true) {
    # Public project, base renders
?>
          <script type="text/javascript">
            renderMapWithData(<?php echo $jsonData; ?>);
          </script>

<?php
} else {
    # Set the most limited public data possible. After correct user
    # validation, it'll render a simple map
?>
          <script type="text/javascript">
            setPublicData(<?php echo $jsonDataLimited; ?>);
          </script>

<?php
   }
   ?>
        </div>
        <div class="col-xs-12">
          <h2>Species List</h2>
          <ul class="species-list">
<?php
          $aWebUri =  "http://amphibiaweb.org/cgi/amphib_query?rel-genus=equals&amp;rel-species=equals&amp;";
          $args = array("where-genus"=>"", "where-species"=>"");
          $speciesList = explode(",", $project["sampled_species"]);
          sort($speciesList);
          $i = 0;
          $realSpecies = array();
          foreach($speciesList as $species) {
              if(empty($species)) continue;
              $i++;
              $realSpecies[] = $species;
              $speciesParts = explode(" ", $species);
              $args["where-genus"] = $speciesParts[0];
              $args["where-species"] = $speciesParts[1];
              $linkUri = $aWebUri . "where-genus=" . $speciesParts[0] . "&amp;where-species=" . $speciesParts[1];
              $html = "<li class=\"aweb-link-species\"> <span class=\"click sciname\" data-href=\"" . $linkUri . "\"data-newtab=\"true\">" . $species . "</span> <paper-icon-button class=\"click\" data-href=\"" . $linkUri . "\" icon=\"icons:open-in-new\" data-newtab=\"true\"></paper-icon-button></li>";
              echo $html;
          }
          if($i === 0) {
              echo "<h3>Sorry, there are no species associated with this project.</h3>";
              $speciesJson = "{}";
          } else {
              $speciesJson = json_encode($realSpecies);
          }
               ?>
          </ul>
          <script type="text/javascript">
            _adp.pageSpeciesList = <?php echo $speciesJson; ?>;
          </script>
        </div>
        <?php } ?>
      </section>
    </main>
    <footer class="row">
      <div class="col-md-8 col-xs-12">
        <copyright-statement copyrightStart="2015">AmphibiaWeb &amp; AmphibianDisease.org</copyright-statement>
      </div>
      <div class="col-md-1 col-xs-3 hidden-xs">
        <paper-icon-button icon="glyphicon-social:github" class="click" data-href="https://github.com/AmphibiaWeb/amphibian-disease-tracker" data-toggle="tooltip" title="Visit us on GitHub" data-newtab="true"></paper-icon-button>
      </div>
      <div class="col-md-1 col-xs-3 hidden-xs">
        <paper-icon-button icon="bug-report" class="click" data-href="https://github.com/AmphibiaWeb/amphibian-disease-tracker/issues/new" data-toggle="tooltip" title="Report an issue" data-newtab="true"></paper-icon-button>
      </div>
      <div class="col-md-2 col-xs-6 hidden-xs">
        Written with <paper-icon-button icon="polymer" class="click" data-href="https://www.polymer-project.org" data-newtab="true"></paper-icon-button>
      </div>
    </footer>
  </body>
</html>