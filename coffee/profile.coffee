###
#
#
#
# See
# https://github.com/AmphibiaWeb/amphibian-disease-tracker/issues/48
###

profileAction = "update_profile"
apiTarget = "#{uri.urlString}/admin-api.php"

window._adp = new Object()

try
  do createOverflowMenu = ->
    ###
    # Create the overflow menu lazily
    ###
    checkLoggedIn (result) ->
      accountSettings = if result.status then """    <paper-item data-href="https://amphibiandisease.org/admin" class="click">
        <iron-icon icon="icons:settings-applications"></iron-icon>
        Account Settings
      </paper-item>
      <paper-item data-href="https://amphibiandisease.org/admin-login.php?q=logout" class="click">
        <span class="glyphicon glyphicon-log-out"></span>
        Log Out
      </paper-item>
      """ else ""
      menu = """
    <paper-menu-button id="header-overflow-menu" vertical-align="bottom" horizontal-offset="-15" horizontal-align="right" vertical-offset="30">
      <paper-icon-button icon="icons:more-vert" class="dropdown-trigger"></paper-icon-button>
      <paper-menu class="dropdown-content">
        #{accountSettings}
        <paper-item data-href="#{uri.urlString}dashboard.php" class="click">
          <iron-icon icon="icons:donut-small"></iron-icon>
          Data Dashboard
        </paper-item>
        <paper-item data-href="https://amphibian-disease-tracker.readthedocs.org" class="click">
          <iron-icon icon="icons:chrome-reader-mode"></iron-icon>
          Documentation
        </paper-item>
        <paper-item data-href="https://github.com/AmphibiaWeb/amphibian-disease-tracker" class="click">
          <iron-icon icon="glyphicon-social:github"></iron-icon>
          Github
        </paper-item>
        <paper-item data-href="https://amphibiandisease.org/about.php" class="click">
          About / Legal
        </paper-item>
      </paper-menu>
    </paper-menu-button>
      """
      $("#header-overflow-menu").remove()
      $("header#header-bar .logo-container + p").append menu
      unless isNull accountSettings
        $("header#header-bar paper-icon-button[icon='icons:settings-applications']").remove()
      bindClicks()
    false

###
# Country codes:
# https://raw.githubusercontent.com/OpenBookPrices/country-data/master/data/countries.json
#
# Formatted via
#
# result = subject.replace(/ +"([A-Z]{2})": +\{\r\n +"name": +"(([\w (),'&-]|\\u00[a-z])+)"(,\r\n +"code": +"\+?([\d ]+)")?\r\n +\},?/mg, '  $1:\r\n    name: "$2"\r\n    code: "$5"');
#
# Then removing the leading and trailing {}
###
isoCountries =
  ZW:
    name: "Zimbabwe"
    code: "263"
  ZM:
    name: "Zambia"
    code: "260"
  ZA:
    name: "South Africa"
    code: "27"
  YT:
    name: "Mayotte"
    code: "262"
  YE:
    name: "Yemen"
    code: "967"
  XK:
    name: "Kosovo"
    code: "383"
  WS:
    name: "Samoa"
    code: "685"
  WF:
    name: "Wallis And Futuna"
    code: "681"
  VU:
    name: "Vanuatu"
    code: "678"
  VN:
    name: "Viet Nam"
    code: "84"
  VI:
    name: "Virgin Islands (US)"
    code: "1 340"
  VG:
    name: "Virgin Islands (British)"
    code: "1 284"
  VE:
    name: "Venezuela, Bolivarian Republic Of"
    code: "58"
  VC:
    name: "Saint Vincent And The Grenadines"
    code: "1 784"
  VA:
    name: "Vatican City State"
    code: "379"
  UZ:
    name: "Uzbekistan"
    code: "998"
  UY:
    name: "Uruguay"
    code: "598"
  US:
    name: "United States"
    code: "1"
  UM:
    name: "United States Minor Outlying Islands"
    code: "1"
  UK:
    name: "United Kingdom"
    code: ""
  UG:
    name: "Uganda"
    code: "256"
  UA:
    name: "Ukraine"
    code: "380"
  TZ:
    name: "Tanzania, United Republic Of"
    code: "255"
  TW:
    name: "Taiwan"
    code: "886"
  TV:
    name: "Tuvalu"
    code: "688"
  TT:
    name: "Trinidad And Tobago"
    code: "1 868"
  TR:
    name: "Turkey"
    code: "90"
  TO:
    name: "Tonga"
    code: "676"
  TN:
    name: "Tunisia"
    code: "216"
  TM:
    name: "Turkmenistan"
    code: "993"
  TL:
    name: "Timor-Leste, Democratic Republic of"
    code: "670"
  TK:
    name: "Tokelau"
    code: "690"
  TJ:
    name: "Tajikistan"
    code: "992"
  TH:
    name: "Thailand"
    code: "66"
  TG:
    name: "Togo"
    code: "228"
  TF:
    name: "French Southern Territories"
    code: ""
  TD:
    name: "Chad"
    code: "235"
  TC:
    name: "Turks And Caicos Islands"
    code: "1 649"
  TA:
    name: "Tristan de Cunha"
    code: "290"
  SZ:
    name: "Swaziland"
    code: "268"
  SY:
    name: "Syrian Arab Republic"
    code: "963"
  SX:
    name: "Sint Maarten"
    code: "1 721"
  SV:
    name: "El Salvador"
    code: "503"
  SU:
    name: "USSR"
    code: ""
  ST:
    name: "S\u00ef\u00bf\u00bdo Tom\u00ef\u00bf\u00bd and Pr\u00ef\u00bf\u00bdncipe"
    code: "239"
  SS:
    name: "South Sudan"
    code: "211"
  SR:
    name: "Suriname"
    code: "597"
  SO:
    name: "Somalia"
    code: "252"
  SN:
    name: "Senegal"
    code: "221"
  SM:
    name: "San Marino"
    code: "378"
  SL:
    name: "Sierra Leone"
    code: "232"
  SK:
    name: "Slovakia"
    code: "421"
  SJ:
    name: "Svalbard And Jan Mayen"
    code: "47"
  SI:
    name: "Slovenia"
    code: "386"
  SH:
    name: "Saint Helena, Ascension And Tristan Da Cunha"
    code: "290"
  SG:
    name: "Singapore"
    code: "65"
  SE:
    name: "Sweden"
    code: "46"
  SD:
    name: "Sudan"
    code: "249"
  SC:
    name: "Seychelles"
    code: "248"
  SB:
    name: "Solomon Islands"
    code: "677"
  SA:
    name: "Saudi Arabia"
    code: "966"
  RW:
    name: "Rwanda"
    code: "250"
  RU:
    name: "Russian Federation"
    code: "7"
  RS:
    name: "Serbia"
    code: "381"
  RO:
    name: "Romania"
    code: "40"
  RE:
    name: "Reunion"
    code: "262"
  QA:
    name: "Qatar"
    code: "974"
  PY:
    name: "Paraguay"
    code: "595"
  PW:
    name: "Palau"
    code: "680"
  PT:
    name: "Portugal"
    code: "351"
  PS:
    name: "Palestinian Territory, Occupied"
    code: "970"
  PR:
    name: "Puerto Rico"
    code: "1 787"
  PN:
    name: "Pitcairn"
    code: "872"
  PM:
    name: "Saint Pierre And Miquelon"
    code: "508"
  PL:
    name: "Poland"
    code: "48"
  PK:
    name: "Pakistan"
    code: "92"
  PH:
    name: "Philippines"
    code: "63"
  PG:
    name: "Papua New Guinea"
    code: "675"
  PF:
    name: "French Polynesia"
    code: "689"
  PE:
    name: "Peru"
    code: "51"
  PA:
    name: "Panama"
    code: "507"
  OM:
    name: "Oman"
    code: "968"
  NZ:
    name: "New Zealand"
    code: "64"
  NU:
    name: "Niue"
    code: "683"
  NR:
    name: "Nauru"
    code: "674"
  NP:
    name: "Nepal"
    code: "977"
  NO:
    name: "Norway"
    code: "47"
  NL:
    name: "Netherlands"
    code: "31"
  NI:
    name: "Nicaragua"
    code: "505"
  NG:
    name: "Nigeria"
    code: "234"
  NF:
    name: "Norfolk Island"
    code: "672"
  NE:
    name: "Niger"
    code: "227"
  NC:
    name: "New Caledonia"
    code: "687"
  NA:
    name: "Namibia"
    code: "264"
  MZ:
    name: "Mozambique"
    code: "258"
  MY:
    name: "Malaysia"
    code: "60"
  MX:
    name: "Mexico"
    code: "52"
  MW:
    name: "Malawi"
    code: "265"
  MV:
    name: "Maldives"
    code: "960"
  MU:
    name: "Mauritius"
    code: "230"
  MT:
    name: "Malta"
    code: "356"
  MS:
    name: "Montserrat"
    code: "1 664"
  MR:
    name: "Mauritania"
    code: "222"
  MQ:
    name: "Martinique"
    code: "596"
  MP:
    name: "Northern Mariana Islands"
    code: "1 670"
  MO:
    name: "Macao"
    code: "853"
  MN:
    name: "Mongolia"
    code: "976"
  MM:
    name: "Myanmar"
    code: "95"
  ML:
    name: "Mali"
    code: "223"
  MK:
    name: "Macedonia, The Former Yugoslav Republic Of"
    code: "389"
  MH:
    name: "Marshall Islands"
    code: "692"
  MG:
    name: "Madagascar"
    code: "261"
  MF:
    name: "Saint Martin"
    code: "590"
  ME:
    name: "Montenegro"
    code: "382"
  MD:
    name: "Moldova"
    code: "373"
  MC:
    name: "Monaco"
    code: "377"
  MA:
    name: "Morocco"
    code: "212"
  LY:
    name: "Libya"
    code: "218"
  LV:
    name: "Latvia"
    code: "371"
  LU:
    name: "Luxembourg"
    code: "352"
  LT:
    name: "Lithuania"
    code: "370"
  LS:
    name: "Lesotho"
    code: "266"
  LR:
    name: "Liberia"
    code: "231"
  LK:
    name: "Sri Lanka"
    code: "94"
  LI:
    name: "Liechtenstein"
    code: "423"
  LC:
    name: "Saint Lucia"
    code: "1 758"
  LB:
    name: "Lebanon"
    code: "961"
  LA:
    name: "Lao People's Democratic Republic"
    code: "856"
  KZ:
    name: "Kazakhstan"
    code: "7"
  KY:
    name: "Cayman Islands"
    code: "1 345"
  KW:
    name: "Kuwait"
    code: "965"
  KR:
    name: "Korea, Republic Of"
    code: "82"
  KP:
    name: "Korea, Democratic People's Republic Of"
    code: "850"
  KN:
    name: "Saint Kitts And Nevis"
    code: "1 869"
  KM:
    name: "Comoros"
    code: "269"
  KI:
    name: "Kiribati"
    code: "686"
  KH:
    name: "Cambodia"
    code: "855"
  KG:
    name: "Kyrgyzstan"
    code: "996"
  KE:
    name: "Kenya"
    code: "254"
  JP:
    name: "Japan"
    code: "81"
  JO:
    name: "Jordan"
    code: "962"
  JM:
    name: "Jamaica"
    code: "1 876"
  JE:
    name: "Jersey"
    code: "44"
  IT:
    name: "Italy"
    code: "39"
  IS:
    name: "Iceland"
    code: "354"
  IR:
    name: "Iran, Islamic Republic Of"
    code: "98"
  IQ:
    name: "Iraq"
    code: "964"
  IO:
    name: "British Indian Ocean Territory"
    code: "246"
  IN:
    name: "India"
    code: "91"
  IM:
    name: "Isle Of Man"
    code: "44"
  IL:
    name: "Israel"
    code: "972"
  IE:
    name: "Ireland"
    code: "353"
  ID:
    name: "Indonesia"
    code: "62"
  IC:
    name: "Canary Islands"
    code: ""
  HU:
    name: "Hungary"
    code: "36"
  HT:
    name: "Haiti"
    code: "509"
  HR:
    name: "Croatia"
    code: "385"
  HN:
    name: "Honduras"
    code: "504"
  HM:
    name: "Heard Island And McDonald Islands"
    code: ""
  HK:
    name: "Hong Kong"
    code: "852"
  GY:
    name: "Guyana"
    code: "592"
  GW:
    name: "Guinea-bissau"
    code: "245"
  GU:
    name: "Guam"
    code: "1 671"
  GT:
    name: "Guatemala"
    code: "502"
  GS:
    name: "South Georgia And The South Sandwich Islands"
    code: ""
  GR:
    name: "Greece"
    code: "30"
  GQ:
    name: "Equatorial Guinea"
    code: "240"
  GP:
    name: "Guadeloupe"
    code: "590"
  GN:
    name: "Guinea"
    code: "224"
  GM:
    name: "Gambia"
    code: "220"
  GL:
    name: "Greenland"
    code: "299"
  GI:
    name: "Gibraltar"
    code: "350"
  GH:
    name: "Ghana"
    code: "233"
  GG:
    name: "Guernsey"
    code: "44"
  GF:
    name: "French Guiana"
    code: "594"
  GE:
    name: "Georgia"
    code: "995"
  GD:
    name: "Grenada"
    code: "473"
  GB:
    name: "United Kingdom"
    code: "44"
  GA:
    name: "Gabon"
    code: "241"
  FX:
    name: "France, Metropolitan"
    code: "241"
  FR:
    name: "France"
    code: "33"
  FO:
    name: "Faroe Islands"
    code: "298"
  FM:
    name: "Micronesia, Federated States Of"
    code: "691"
  FK:
    name: "Falkland Islands"
    code: "500"
  FJ:
    name: "Fiji"
    code: "679"
  FI:
    name: "Finland"
    code: "358"
  EU:
    name: "European Union"
    code: "388"
  ET:
    name: "Ethiopia"
    code: "251"
  ES:
    name: "Spain"
    code: "34"
  ER:
    name: "Eritrea"
    code: "291"
  EH:
    name: "Western Sahara"
    code: "212"
  EG:
    name: "Egypt"
    code: "20"
  EE:
    name: "Estonia"
    code: "372"
  EC:
    name: "Ecuador"
    code: "593"
  EA:
    name: "Ceuta, Mulilla"
    code: ""
  DZ:
    name: "Algeria"
    code: "213"
  DO:
    name: "Dominican Republic"
    code: "1 809"
  DM:
    name: "Dominica"
    code: "1 767"
  DK:
    name: "Denmark"
    code: "45"
  DJ:
    name: "Djibouti"
    code: "253"
  DG:
    name: "Diego Garcia"
    code: ""
  DE:
    name: "Germany"
    code: "49"
  CZ:
    name: "Czech Republic"
    code: "420"
  CY:
    name: "Cyprus"
    code: "357"
  CX:
    name: "Christmas Island"
    code: "61"
  CW:
    name: "Curacao"
    code: "599"
  CV:
    name: "Cabo Verde"
    code: "238"
  CU:
    name: "Cuba"
    code: "53"
  CR:
    name: "Costa Rica"
    code: "506"
  CP:
    name: "Clipperton Island"
    code: ""
  CO:
    name: "Colombia"
    code: "57"
  CN:
    name: "China"
    code: "86"
  CM:
    name: "Cameroon"
    code: "237"
  CL:
    name: "Chile"
    code: "56"
  CK:
    name: "Cook Islands"
    code: "682"
  CI:
    name: "Cote d'Ivoire"
    code: "225"
  CH:
    name: "Switzerland"
    code: "41"
  CG:
    name: "Republic Of Congo"
    code: "242"
  CF:
    name: "Central African Republic"
    code: "236"
  CD:
    name: "Democratic Republic Of Congo"
    code: "243"
  CC:
    name: "Cocos (Keeling) Islands"
    code: "61"
  CA:
    name: "Canada"
    code: "1"
  BZ:
    name: "Belize"
    code: "501"
  BY:
    name: "Belarus"
    code: "375"
  BW:
    name: "Botswana"
    code: "267"
  BV:
    name: "Bouvet Island"
    code: ""
  BT:
    name: "Bhutan"
    code: "975"
  BS:
    name: "Bahamas"
    code: "1 242"
  BR:
    name: "Brazil"
    code: "55"
  BQ:
    name: "Bonaire, Saint Eustatius And Saba"
    code: "599"
  BO:
    name: "Bolivia, Plurinational State Of"
    code: "591"
  BN:
    name: "Brunei Darussalam"
    code: "673"
  BM:
    name: "Bermuda"
    code: "1 441"
  BL:
    name: "Saint Barth\u00ef\u00bf\u00bdlemy"
    code: "590"
  BJ:
    name: "Benin"
    code: "229"
  BI:
    name: "Burundi"
    code: "257"
  BH:
    name: "Bahrain"
    code: "973"
  BG:
    name: "Bulgaria"
    code: "359"
  BF:
    name: "Burkina Faso"
    code: "226"
  BE:
    name: "Belgium"
    code: "32"
  BD:
    name: "Bangladesh"
    code: "880"
  BB:
    name: "Barbados"
    code: "1 246"
  BA:
    name: "Bosnia & Herzegovina"
    code: "387"
  AZ:
    name: "Azerbaijan"
    code: "994"
  AX:
    name: "\u00ef\u00bf\u00bdland Islands"
    code: "358"
  AW:
    name: "Aruba"
    code: "297"
  AU:
    name: "Australia"
    code: "61"
  AT:
    name: "Austria"
    code: "43"
  AS:
    name: "American Samoa"
    code: "1 684"
  AR:
    name: "Argentina"
    code: "54"
  AQ:
    name: "Antarctica"
    code: "672"
  AO:
    name: "Angola"
    code: "244"
  AM:
    name: "Armenia"
    code: "374"
  AL:
    name: "Albania"
    code: "355"
  AI:
    name: "Anguilla"
    code: "1 264"
  AG:
    name: "Antigua And Barbuda"
    code: "1 268"
  AF:
    name: "Afghanistan"
    code: "93"
  AE:
    name: "United Arab Emirates"
    code: "971"
  AD:
    name: "Andorra"
    code: "376"
  AC:
    name: "Ascension Island"
    code: "247"


loadUserBadges = ->
  ###
  #
  ###
  false


setupProfileImageUpload = (uploadFormId = "profile-image-uploader", bsColWidth = "", callback) ->
  ###
  # Bootstrap an uploader for images
  ###
  # Check for the existence of the uploader form; if it's not there,
  # create it
  selector = "##{uploadFormId}"
  author = $.cookie("#{adminParams.domain}_link")
  uploadIdentifier = window.profileUid
  projectIdentifier = _adp.projectIdentifierString
  unless $(selector).exists()
    # Create it
    console.info "Creating uploader to append"
    html = """
    <form id="#{uploadFormId}-form" class="#{bsColWidth} clearfix">
      <p class="visible-xs-block">Tap the button to upload a file</p>
      <fieldset class="hidden-xs">
        <legend class="sr-only">Profile Image</legend>
        <div id="#{uploadFormId}" class="media-uploader outline media-upload-target">
        </div>
      </fieldset>
    </form>
    """
    placeIntoSelector = "main #upload-container-section"
    $(placeIntoSelector).append html
    unless isNull bsColWidth
      $(placeIntoSelector).addClass "row"
    console.info "Appended upload form", $(placeIntoSelector).exists()
    $(selector).submit (e) ->
      e.preventDefault()
      e.stopPropagation()
      return false
  # Validate the user before guessing
  verifyLoginCredentials ->
    window.dropperParams ?= new Object()
    window.dropperParams.dropTargetSelector = selector
    window.dropperParams.uploadPath = "../../users/profiles/"
    window.dropperParams.uploadText = "Drop your image here to set a new profile picture"
    # Need to make this re-initialize ...
    needsInit = window.dropperParams.hasInitialized is true
    loadJS "helpers/js-dragdrop/client-upload.min.js", ->
      window.dropperParams.mimeTypes = "image/*"
      # Successfully loaded the file
      console.info "Loaded drag drop helper"
      if needsInit
        console.info "Reinitialized dropper"
        try
          window.dropperParams.initialize()
        catch
          console.warn "Couldn't reinitialize dropper!"
      window.dropperParams.postUploadHandler = (file, result) ->
        ###
        # The callback function for handleDragDropImage
        #
        # The "file" object contains information about the uploaded file,
        # such as name, height, width, size, type, and more. Check the
        # console logs in the demo for a full output.
        #
        # The result object contains the results of the upload. The "status"
        # key is true or false depending on the status of the upload, and
        # the other most useful keys will be "full_path" and "thumb_path".
        #
        # When invoked, it calls the "self" helper methods to actually do
        # the file sending.
        ###
        # Clear out the file uploader
        window.dropperParams.dropzone.removeAllFiles()

        if typeof result isnt "object"
          console.error "Dropzone returned an error - #{result}"
          toastStatusMessage "There was a problem with the server handling your image. Please try again."
          return false
        unless result.status is true
          # Yikes! Didn't work
          result.human_error ?= "There was a problem uploading your image."
          toastStatusMessage "#{result.human_error}"
          console.error("Error uploading!",result)
          return false
        try
          console.info "Server returned the following result:", result
          console.info "The script returned the following file information:", file
          pathPrefix = window.dropperParams.uploadPath
          # path = "helpers/js-dragdrop/#{result.full_path}"
          # Replace full_path and thumb_path with "wrote"
          fileName = result.full_path.split("/").pop()
          thumbPath = result.wrote_thumb
          mediaType = result.mime_provided.split("/")[0]
          longType = result.mime_provided.split("/")[1]
          linkPath = if file.size < 5*1024*1024 or mediaType isnt "image" then "#{pathPrefix}#{result.wrote_file}" else "#{pathPrefix}#{thumbPath}"
          previewHtml = switch mediaType
            when "image"
              """
              <div class="uploaded-media center-block" data-system-file="#{fileName}" data-link-path="#{linkPath}">
                <img src="#{linkPath}" alt='Uploaded Image' class="img-circle thumb-img img-responsive"/>
                  <p class="text-muted">
                    #{file.name} -> #{fileName}
                    (<a href="#{linkPath}" class="newwindow" download="#{file.name}">
                      Original Image
                    </a>)
                  </p>
              </div>
              """
            when "audio" then """
            <div class="uploaded-media center-block" data-system-file="#{fileName}">
              <audio src="#{linkPath}" controls preload="auto">
                <span class="glyphicon glyphicon-music"></span>
                <p>
                  Your browser doesn't support the HTML5 <code>audio</code> element.
                  Please download the file below.
                </p>
              </audio>
              <p class="text-muted">
                #{file.name} -> #{fileName}
                (<a href="#{linkPath}" class="newwindow" download="#{file.name}">
                  Original Media
                </a>)
              </p>
            </div>
            """
            when "video" then """
            <div class="uploaded-media center-block" data-system-file="#{fileName}">
              <video src="#{linkPath}" controls preload="auto">
                <img src="#{pathPrefix}#{thumbPath}" alt="Video Thumbnail" class="img-responsive" />
                <p>
                  Your browser doesn't support the HTML5 <code>video</code> element.
                  Please download the file below.
                </p>
              </video>
              <p class="text-muted">
                #{file.name} -> #{fileName}
                (<a href="#{linkPath}" class="newwindow" download="#{file.name}">
                  Original Media
                </a>)
              </p>
            </div>
            """
            else
              """
              <div class="uploaded-media center-block" data-system-file="#{fileName}" data-link-path="#{linkPath}">
                <span class="glyphicon glyphicon-file"></span>
                <p class="text-muted">#{file.name} -> #{fileName}</p>
              </div>
              """
          # Append the preview HTML
          $(window.dropperParams.dropTargetSelector).before previewHtml
          # Finally, execute handlers for different file types
          $("#validator-progress-container").remove()
          checkPath = linkPath.slice 0
          cp2 = linkPath.slice 0
          extension = cp2.split(".").pop()
          switch mediaType
            when "application"
              # Another switch!
              console.info "Checking #{longType} in application"
              switch longType
                # Fuck you MS, and your terrible MIME types
                when "vnd.openxmlformats-officedocument.spreadsheetml.sheet", "vnd.ms-excel"
                  excelHandler(linkPath)
                when "vnd.ms-office"
                  switch extension
                    when "xls"
                      excelHandler linkPath
                    else
                      stopLoadError "Sorry, we didn't understand the upload type."
                      return false
                when "zip", "x-zip-compressed"
                  # Some servers won't read it as the crazy MS mime type
                  # But as a zip, instead. So, check the extension.
                  #
                  if file.type is "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" or extension is "xlsx"
                    excelHandler(linkPath)
                  else
                    zipHandler(linkPath)
                when "x-7z-compressed"
                  _7zHandler(linkPath)
            when "text" then csvHandler(linkPath)
            when "image" then imageHandler(linkPath, result)
        catch e
          console.error "There was a post-processing error: #{e.message}"
          console.warn e.stack
          toastStatusMessage "Your file uploaded successfully, but there was a problem in the post-processing."
      # Callback if exists
      if typeof callback is "function"
        callback()
    false
  false


imageHandler = (path, ajaxResult = null) ->
  ###
  # Take the image path provided and associate that with the user
  # profile iamge
  #
  #
  ###
  startLoad()
  # Get a canonical path
  relativePath = path.replace(/^(\.\.\/)*([\w\/]+\.(jpg|jpeg|png|bmp|gif|webp|pnga))$/img, "$2")
  if isNull relativePath
    console.error "Invalid path '#{path}' parsed to invalid canonical path", relativePath
    stopLoadError "Processing error. Please try again."
    return false
  # Build a JSON to post over
  data =
    profile_image_path: relativePath
  console.log "Going to save", data
  pdata = jsonTo64 data
  args = "perform=write_profile_image&data=#{pdata}"
  $.post apiTarget, args, "json"
  .done (result) ->
    console.log "Save got", result
    unless result.status is true
      message = result.human_error ? result.error ? "Unknown error"
      stopLoadError "There was an error saving your profile image - #{message}. Please try again later."
      return false
    # Replace the profile image
    try
      imagePath = result.image_uri
      ts = "?v=#{Date.now()}"
      imageNew = """
      <img class="profile-image img-responsive"
        id="user-profile-image"
        src="#{result.tiny_image_uri}#{ts}"
        srcset="#{imagePath}#{ts} 10x, #{result.small_image_uri}#{ts} 4x, #{result.tiny_image_uri}#{ts} 1x" alt="Profile image" />
      """
      $("#user-profile-image").replaceWith imageNew
      html = """
      <div class="alert alert-info col-xs-12">
        <a href="#" class="alert-link hard-refresh-page">Click here to refresh</a> and see your new profile image. Be sure to save any changes first.
      </div>
      """
      # $(".profile-image-container").html html
      $(".hard-refresh-page").click ->
        document.location.reload(true)
      console.info "Replaced #user-profile-image", html
    catch e
      console.warn "Couldn't replace old profile image - #{e.message}"
      console.warn e.stack
    $(".uploaded-media").remove()
    stopLoad()
    toastStatusMessage "Successfully updated your profile image"
    false
  .fail (result, status) ->
    console.error "Error!", result, status
    stopLoadError "There was a problem saving to the server."
    $(".uploaded-media").remove()
    false
  false

window.imageHandler = imageHandler



getProfilePrivacy = ->
  ###
  #
  ###
  privacyParams = new Object()
  for privacyGroup in $(".privacy-group")
    privacyTarget = $(privacyGroup).attr "data-group"
    toggles = $(privacyGroup).find("paper-toggle-button")
    for toggle in toggles
      privacyScope = $(toggle).attr "data-scope"
      unless privacyParams[privacyTarget]?
        privacyParams[privacyTarget] = new Object()
      privacyParams[privacyTarget][privacyScope] = p$(toggle).checked
  privacyParams


conditionalLoadAccountSettingsOptions = ->
  ###
  # Verify the account ownership, and if true, provide options for
  # various account settings.
  #
  # Largely acts as links back to admin-login.php
  ###
  false


constructProfileJson = (encodeForPosting = false, callback)->
  ###
  # Read all the fields and return a JSON formatted for the database
  # field
  #
  # See Github Issue #48
  #
  # @param bool encodeForPosting -> when true, returns a URI-encoded
  #   base64 string, rather than an actual object.
  ###
  response = false
  # Build it
  if typeof window.publicProfile is "object"
    tmp = window.publicProfile
  else
    tmp = new Object()
  inputs = $(".profile-data:not(.from-base-profile) .user-input")
  for el in inputs
    val = p$(el).value
    key = $(el).attr "data-source"
    key = key.replace "-", "_"
    key = switch key
      when "institution"
        "name"
      else key
    parentKey = $(el).parents("[data-source]").attr "data-source"
    unless typeof tmp[parentKey] is "object"
      tmp[parentKey] = new Object()
    tmp[parentKey][key] = val
  tmp.profile = p$("#bio-profile .user-input").value
  privacy = getProfilePrivacy()
  tmp.privacy = privacy
  # Prep it
  validateAddress tmp.institution, (newAddressObj) ->
    tmp.place = newAddressObj
    if encodeForPosting
      response = post64 tmp
    else
      response = tmp
    console.info "Sending back response", response
    if typeof callback is "function"
      callback response
    else
      console.warn "No callback function! Profile construction got", response
    delete tmp.institution
    window.publicProfile = tmp
    false
  if encodeForPosting
    response = post64 tmp
  else
    response = tmp
  window.publicProfile = tmp
  console.log "Non-validated response object:", response
  response


formatSocial = ->
  isGood = true
  el = if window.isViewingSelf then "paper-input" else "paper-fab"
  for fab in $(".social #{el}")
    try
      icon = $(fab).attr "icon"
      network = icon.split(":").pop()
      link = $(fab).attr "data-href"
    catch
      try
        network = $(fab).attr "data-source"
        network = network.replace /_/g, "-"
        link = p$(fab).value
      catch
        console.error "borkedy"
    realHref = link
    switch network
      when "twitter"
        if link.search("@") is 0
          realHref = "https://twitter.com/#{link.slice(1)}"
        else if link.match(/^https?:\/\/(www\.)?twitter.com\/\w+$/m)
          realHref = link
        else if link.match(/^\w+$/m)
          realHref = "https://twitter.com/#{link}"
        else
          realHref = ""
      when "google-plus"
        if link.search(/\+/) is 0
          realHref = "https://google.com/#{link}"
        else if link.match(/^https?:\/\/((plus|www)\.)?google.com\/(\+\w+|\d+)$/m)
          realHref = link
        else if link.match(/^\w+$/m)
          realHref = "https://google.com/+#{link}"
        else
          realHref = ""
      when "facebook"
        if link.match(/^https?:\/\/((www)\.)?facebook.com\/\w+$/m)
          realHref = link
        else if link.match(/^\w+$/m)
          realHref = "https://facebook.com/#{link}"
        else
          realHref = ""
    if isNull(realHref) and not isNull(link)
      console.warn "#{network} has a questionable link", link, realHref
      try
        networkCss = network.replace /-/g, "_"
        p$(".#{networkCss} paper-input").errorMessage = "We couldn't understand this profile"
        p$(".#{networkCss} paper-input").invalid = true
        isGood = false

    $(fab)
    .unbind()
    .attr "data-href", realHref
  bindClicks("paper-fab")
  isGood

validateAddress = (addressObject, callback) ->
  ###
  # Get extra address validation information and save it
  #
  ###
  addressObject.country_code = addressObject.country_code.toUpperCase()
  isoCountry = isoCountries[addressObject.country_code]
  unless isoCountry?
    stopLoadError "Sorry, '#{addressObject.country_code}' is an invalid country code"
  newAddressObject = addressObject
  newAddressObject.validated = false
  newAddressObject.partially_validated = false
  filter =
    country: addressObject.country_code ? "US"
    postalCode: addressObject.zip
  addressString = "#{addressObject.street_number} #{addressObject.street}"
  console.log "Attempting validation with", addressString, filter
  geo.geocode addressString, filter, (result) ->
    console.log "Address validator got", result
    newAddressObject.validated = result.partial_match isnt true
    newAddressObject.partially_validated = result.partial_match is true
    newAddressObject.parsed = result
    newAddressObject.state = result.google.administrative_area_level_1 ? ""
    newAddressObject.city = result.google.locality ? ""
    if newAddressObject.validated
      newAddressObject.street_number = result.google.street_number ? addressObject.street_number
      newAddressObject.street = result.google.route ? addressObject.street
      if result.google.postal_code_suffix?
        newAddressObject.zip += "-#{result.google.postal_code_suffix}"
      addressString = "#{newAddressObject.street_number} #{newAddressObject.street}"
    humanHtml = """
    #{addressString}<br/>
    #{newAddressObject.city}, #{newAddressObject.state} #{newAddressObject.zip}<br/>
    #{isoCountry.name}
    """
    newAddressObject.human_html = humanHtml
    console.info "New address object", newAddressObject
    if typeof callback is "function"
      callback newAddressObject
    else
      console.warn "No callback fucntion! Address validation got", newAddressObject
    false
  false

cleanupAddressDisplay = ->
  ###
  # Display human-helpful address information, like city/state
  ###
  if window.publicProfile?
    addressObj = window.publicProfile.place
    if addressObj.human_html?
      mapsSearch = encodeURIComponent addressObj.human_html.replace(/(<br\/>|\n|\\n)/g, " ")
      # col-xs-12 col-md-3 col-lg-4
      postHtml = """
      <div class="">
        <paper-fab mini icon="maps:map" data-href="https://www.google.com/maps/search/#{mapsSearch}" class="click materialblue newwindow" data-newtab="true" data-toggle="tooltip" title="View in Google Maps">
        </paper-fab>
      </div>
      """
      labelHtml = """
      <label class="col-xs-4 capitalize">
        Address
      </label>
      """
      $("address")
      .html addressObj.human_html.replace /\\n/g, "<br/> "
      .addClass "col-xs-8 col-md-5 col-lg-4"
      .before labelHtml
      .after postHtml
      .parent().addClass("row clearfix")
    else
      console.warn "Human HTML not yet defined for this user"
  else
    console.warn "Public profile not set up"
  false

saveProfileChanges = ->
  ###
  # Post the appropriate JSON to the server and give user feedback
  # based on the response
  ###
  startLoad()
  isGood = true
  for input in $("paper-input")
    try
      result = p$(input).validate()
      if result is false
        isGood = false
  isGood = isGood and formatSocial()
  unless isGood
    stopLoadError "Please check all required fields are completed"
    return false
  constructProfileJson false,  (data) ->
    console.log "Going to save", data
    pdata = jsonTo64 data
    args = "perform=#{profileAction}&data=#{pdata}"
    $("#save-profile").attr "disabled", "disabled"
    $.post apiTarget, args, "json"
    .done (result) ->
      console.log "Save got", result
      unless result.status is true
        $("#save-profile").removeAttr "disabled"
        message = result.human_error ? result.error ? "Unknown error"
        stopLoadError "There was an error saving - #{message}. Please try again later."
        return false
      $("#save-profile").attr "disabled", "disabled"
      stopLoad()
      false
    .fail (result, status) ->
      console.error "Error!", result, status
      stopLoadError "There was a problem saving to the server."
      false
  false


setupUserChat = ->
  $(".conversation-list li").click ->
    # Load that user's chat
    chattingWith = $(this).attr "data-uid"
    foo()
    false
  $("#compose-message").keyup (e) ->
    kc = if e.keyCode then e.keyCode else e.which
    if kc is 13
      sendChat()
    false
  $(".send-chat").click ->
    sendChat()
    false
  sendChat = ->
    toastStatusMessage "Would send message"
    false
  false


forceUpdateMarked = ->
  val = $("marked-element script").text()
  valReal = val.replace /\\n/g, "\n"
  p$("marked-element").markdown = valReal


copyLink = (zeroClipObj = _adp.zcClient, zeroClipEvent, html5 = true) ->
  url = p$("#profile-link-field").value
  successMessage = "Profile URL copied to clipboard"
  if html5
    # http://caniuse.com/#feat=clipboard
    try
      clipboardData =
        dataType: "text/plain"
        data: url
        "text/plain": url
      clip = new ClipboardEvent("copy", clipboardData)
      document.dispatchEvent(clip)
      toastStatusMessage successMessage
      return false
    catch e
      console.error "Error creating copy: #{e.message}"
      console.warn e.stack
  console.warn "Can't use HTML5"
  # http://zeroclipboard.org/
  # https://github.com/zeroclipboard/zeroclipboard
  if zeroClipObj?
    zeroClipObj.setData clipboardData
    if zeroClipEvent?
      zeroClipEvent.setData clipboardData
    zeroClipObj.on "aftercopy", (e) ->
      if e.data["text/plain"]
        toastStatusMessage successMessage
      else
        toastStatusMessage "Error copying to clipboard"
    zeroClipObj.on "error", (e) ->
      #https://github.com/zeroclipboard/zeroclipboard/blob/master/docs/api/ZeroClipboard.md#error
      console.error "Error copying to clipboard"
      console.warn "Got", e
      if e.name is "flash-overdue"
        # ZeroClipboard.destroy()
        if _adp.resetClipboard is true
          console.error "Resetting ZeroClipboard didn't work!"
          return false
        ZeroClipboard.on "ready", ->
          # Re-call
          _adp.resetClipboard = true
          copyLink()
        _adp.zcClient = new ZeroClipboard $("#copy-profile-link").get 0
      # Case for no flash at all
      if e.name is "flash-disabled"
        # stuff
        console.info "No flash on this system"
        ZeroClipboard.destroy()
        $("#copy-profile-link")
        .tooltip("destroy") # Otherwise stays on click: http://getbootstrap.com/javascript/#tooltipdestroy
        toastStatusMessage "Clipboard copying isn't available on your system"
  else
    console.error "Can't use HTML, and ZeroClipboard wasn't passed"
  false


searchProfiles = ->
  ###
  # Handler to search profiles
  ###
  search = $("#profile-search").val()
  if isNull search
    $("#profile-result-container").empty()
    return false
  item = p$("#search-filter").selectedItem
  cols = $(item).attr "data-cols"
  console.info "Searching on #{search} ... in #{cols}"
  # POST a request to the server for profiles matching this
  args = "action=search_users&q=#{search}&cols=#{cols}"
  $.post "#{uri.urlString}api.php", args, "json"
  .done (result) ->
    console.info result
    if result.status isnt true
      console.error "Problem searching profiles!"
      html = """
      <div class="alert alert-warning">
        <p>There was an error searching profiles.</p>
      </div>
      """
      $("#profile-result-container").html html
      return false
    html = ""
    showList = new Array()
    profiles = Object.toArray result.result
    if profiles.length > 0
      for profile in profiles
        showList.push profile.name
        button = """
        <button class="btn btn-primary search-profile-link" data-href="#{uri.urlString}profile.php?id=#{profile.uid}" data-uid="#{profile.uid}">
          #{profile.full_name} / #{profile.handle}
        </button>
        """
        html += "<li class='profile-search-result'>#{button}</li>"
    else
      s = result.search ? search
      html = "<p><em>No results found for \"<strong>#{s}</strong>\""
    $("#profile-result-container").html html
    bindClicks(".search-profile-link")
  .fail (result, status) ->
    console.error result, status
  false

verifyLoginCredentials = (callback, skip) ->
  ###
  # Checks the login credentials against the server.
  # This should not be used in place of sending authentication
  # information alongside a restricted action, as a malicious party
  # could force the local JS check to succeed.
  # SECURE AUTHENTICATION MUST BE WHOLLY SERVER SIDE.
  ###
  adminParams = new Object()
  adminParams.domain = "amphibiandisease"
  adminParams.apiTarget = "admin-api.php"
  adminParams.adminPageUrl = "https://#{adminParams.domain}.org/admin-page.html"
  adminParams.loginDir = "admin/"
  adminParams.loginApiTarget = "#{adminParams.loginDir}async_login_handler.php"
  hash = $.cookie("#{adminParams.domain}_auth")
  secret = $.cookie("#{adminParams.domain}_secret")
  link = $.cookie("#{adminParams.domain}_link")
  args = "hash=#{hash}&secret=#{secret}&dblink=#{link}"
  $.post adminParams.loginApiTarget, args, "json"
  .done (result) ->
    if result.status is true
      unless _adp?
        window._adp = new Object()
      _adp.isUnrestricted = result.unrestricted
      if typeof callback is "function"
        callback(result)
    else
      # Refresh it
      if window.isViewingSelf is true
        document.location.reload(true)
      else
        console.info "Bad credentials, but not self-viewing"
  .fail (result,status) ->
    # Throw up some warning here
    #$("main #main-body").html("<div class='bs-callout-danger bs-callout'><h4>Couldn't verify login</h4><p>There's currently a server problem. Try back again soon.</p></div>")
    console.error "There was a problem verifying your login state"
    false
  false


cascadePrivacyToggledState = (el, cascadeDown = true) ->
  ###
  #
  ###
  try
    # Look at toggle
    isChecked = p$(el).checked
    level = toInt $(el).attr "data-level"
    container = $(el).parents(".privacy-group[data-group]")
    toggles = $(container).find("[data-scope]")
    if isChecked
      # If visible, all more restrictive criteria are also visible
      for toggle in toggles
        toggleLevel = toInt $(toggle).attr "data-level"
        if toggleLevel > level
          p$(toggle).checked = isChecked
          p$(toggle).disabled = true
        else if toggleLevel < level and cascadeDown
          # Less restrictive criteria should be made editable
          p$(toggle).checked = not isChecked
          p$(toggle).disabled = false
    else if cascadeDown
      # Unchecked item (eg, "not visible")
      for toggle in toggles
        toggleLevel = toInt $(toggle).attr "data-level"
        if toggleLevel > level
          p$(toggle).disabled = false
  catch
    console.error "An invalid element was passed cascading privacy toggles"
  false


initialCascadeSetup = ->
  scopesInOrder = [
    "collaborators"
    "members"
    "public"
    ]
  for scope in scopesInOrder
    selector = ".privacy-toggle [data-scope='#{scope}']"
    for element in $(selector)
      cascadePrivacyToggledState(element, false)
  false


######################################
# Profile Captcha Fill Helpers
######################################


renderCaptchas = (response) ->
  ###
  # Renders the captchas into their respective elements
  ###
  animateLoad()
  dest = "#{uri.urlString}api.php"
  profile = window.profileUid ? uri.o.param("id")
  args = "action=is_human&recaptcha_response=#{response}&user=#{profile}"
  $.post dest, args, "json"
  .done (result) ->
    console.info "Checked response"
    console.log result
    # Replace the things
    replaceMap =
      email: result.response.username
      phone: result.response.phone
      department_phone: result.response.public_profile.place.department_phone
    for element in $(".g-recaptcha")
      $(element).removeClass "g-recaptcha"
      lookup = $(element).attr "data-type"
      data = replaceMap[lookup]
      # Format it based on lookup type
      # Fill the replacement
      if lookup isnt "email"
        html = """
        <p class="col-xs-8">
          #{data}
        </p>
        """
      else
        html = """
        <p class="col-xs-5">
          #{data}
        </p>
        <paper-fab mini icon="communication:email" class="materialblue do-mailto col-xs-3" data-email="#{data}"></paper-fab>
        """
      $(element).replaceWith html
    try
      $(".do-mailto")
      .unbind()
      .click ->
        email = $(this).attr "data-email"
        document.location.href = "mailto:#{email}"
        false
    stopLoad()
    false
  .fail (result, status) ->
    stopLoadError "Sorry, there was a problem getting the contact information"
    false
  false




$ ->
  # On load page events
  try
    loadUserBadges()
  try
    conditionalLoadAccountSettingsOptions()
  $("#expose-uploader").click ->
    $("#upload-container-section").removeAttr "hidden"
    $(this).remove()
  $("#save-profile").click ->
    saveProfileChanges()
    false
  $(".user-input").keyup ->
    $("#save-profile").removeAttr "disabled"
    false
  $("paper-toggle-button").on "change", ->
    cascadePrivacyToggledState(this)
    $("#save-profile").removeAttr "disabled"
    false
  do cleanInputFormat = ->
    unless Polymer?.RenderStatus?._ready
      #console.warn "Delaying input setup until Polymer.RenderStatus is ready"
      delay 500, ->
        cleanInputFormat()
      return false
    console.info "Setting up input values"
    try
      formatSocial()
      forceUpdateMarked()
    try
      initialCascadeSetup()
    try
      isoCC = window.publicProfile.place.country_code
      callingCode = isoCountries[isoCC].code
    unless isNumber callingCode
      callingCode = 1
    for gpi in $("gold-phone-input")
      value = $(gpi).parent().attr "data-value"
      unless isNull value
        # Fix the formatting of the display
        p$(gpi).value = toInt value
        p$(gpi).countryCode = callingCode
    for phone in $(".phone-number")
      plainValue = $(phone).text()
      if isNumber plainValue
        value = "+#{callingCode}#{plainValue}"
        html = """
        <a href="tel:#{value}" class="phone-number-parsed">
          <iron-icon icon="communication:phone" data-toggle="tooltip" title="Click to call"></iron-icon>
          #{plainValue}
        </a>
        """
        $(phone).replaceWith html
  if window.isViewingSelf isnt true
    console.info "Foreign profile"
    cleanupAddressDisplay()
  else
    console.info "Doing self-profile checks"
    setupUserChat()
    verifyLoginCredentials()
    try
      setupProfileImageUpload()
  $("#profile-search").keyup (e) ->
    unless isNull $(this).val()
      searchProfiles.debounce()
  zcConfig =
    swfPath: "bower_components/zeroclipboard/dist/ZeroClipboard.swf"
  _adp.zcConfig = zcConfig
  ZeroClipboard.config zcConfig
  _adp.zcClient = new ZeroClipboard $("#copy-profile-link").get 0
  # client.on "copy", (e) =>
  #   copyLink(this, e)
  $("#copy-profile-link").click ->
    copyLink _adp.zcClient
  checkFileVersion false, "js/profile.js"
  false
