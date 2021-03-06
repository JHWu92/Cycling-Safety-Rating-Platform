<?php
# ===========================
# DB connection constants
# ===========================

# for PDO
$DB_USER = '';
$DB_PASSWD = '';
$dbname = "cyclings_vid1";  # or other name for the database you prefer
$dbhost = "your-database-host-name";
$dbport = 3306;  # your database port
$DB_DSN = "mysql:host={$dbhost};port={$dbport};dbname={$dbname}";  # by default it use MySQL database. If you use other database, please modify the DSN accordingly
$DB_DBNAME = dbname;

$TABLE_USERS = "Users";
$TABLE_SEG = "segment";
$TABLE_VIDEO = "video";
$TABLE_VIDEO2SEGS = "video2segs";
$TABLE_RATING = "Rating";
$TABLE_LOGINLOG = "loginLog";

$TABL_VIDEO_FIELD_URL = "URL";
$TABL_USERS_FIELD_EXP = "experienceLevel";
$TABL_USERS_FIELD_UID = "user_id";
$TABL_USERS_FIELD_SURVEY = "has_survey";
$TB_U_COL_BK_PURPOSE = "bk_purpose";
$TB_U_COL_AGE = "age";
$TB_U_COL_ETHNICITY = "ethnicity";
$TB_U_COL_EDU = "edu";
$TB_U_COL_MARITAL = "marital";
$TB_U_COL_GENDER = "gender";
$TB_U_COL_DRIVER = "driver";
$TB_U_COL_CAR = "car";
$TB_U_COL_HHINCOME = "household_income";
$TB_U_COL_RESIDENCE = "residence";
$TB_U_COL_BK_TYPE = "bk_type";
$TB_U_COL_BK_TYPE_OTHER = "bk_type_other";
$TB_COL_TIMESTAMP = 'UTCts';
$TB_COL_TIMEZONE = 'timezone';
$TB_COL_USERAGENT = 'userAgent';
$TB_COL_ISMOBILE = 'isMobile';
$TB_COL_ISTABLET = 'isTablet';
$TB_COL_ISANDROID = 'isAndroid';
$TB_COL_ISIOS = 'isIOS';
$TB_COL_WATCHED = "watched";
$TB_COL_INTERACTION = "interaction";
$TB_COL_LID = "lid";

# ===========================
# Router
# ===========================
$DOMAIN_URL = "/";
$PAGE_SURVEY = "survey.php";
$PAGE_SURVEY_SAVE = "survey-save.php";
$PAGE_EXP = "exp-lvl.php";
$PAGE_SAVE_EXP = "exp-lvl-save.php";
$PAGE_RATE_VIDEO = "rate-video.html";
$PAGE_USER_INFO = "user_info.html";
$PAGE_INDEX = "index.html";
$PAGE_SHOW_MAP = "show_map.php";
$PAGE_LOGIN_FIRST = "login-first.html";

# ===========================
# form or session variables
# ===========================
$SESS_EMAIL = "email";  # update check-email.html form when changing this.
$SESS_EXPLV = "explv"; 
$SESS_SURVEY = "has_survey";  # update check-email.html form when changing this.
$SESS_USER_ID = "user_id";
$SESS_LOGIN_ID = $TB_COL_LID;
$SESS_LOGIN = "is_logged_in";
$SESS_VIDEO_ID = "videoid";

$POST_FAMILIAR_ST = "familiar";  # update rate-video.html form when changing this.
$POST_SCORE = "score";   # update rate-video.html form when changing this.
$POST_COMMENT = "comment";  # update rate-video.html form when changing this.
$POST_TAG = "tag";
$POST_WATCHED = $TB_COL_WATCHED;
$POST_INTERACTION = $TB_COL_INTERACTION;

$SURVEY_COLS = array($TB_U_COL_BK_PURPOSE, $TB_U_COL_AGE, $TB_U_COL_ETHNICITY,
$TB_U_COL_EDU,$TB_U_COL_MARITAL, $TB_U_COL_GENDER, $TB_U_COL_DRIVER,
$TB_U_COL_CAR, $TB_U_COL_HHINCOME, $TB_U_COL_RESIDENCE, $TB_U_COL_BK_TYPE)

?>