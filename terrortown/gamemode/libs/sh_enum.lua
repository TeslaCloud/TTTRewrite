-- Enumerations.

-- Round status consts
ROUND_WAIT   = 1
ROUND_PREP   = 2
ROUND_ACTIVE = 3
ROUND_POST   = 4

-- Player roles
-- We change enumerations to strings, because new role system uses strings.
ROLE_INNOCENT  = "innocent"
ROLE_TRAITOR   = "traitor"
ROLE_DETECTIVE = "detective"
ROLE_MANIAC	   = "maniac"
ROLE_NONE = ROLE_INNOCENT

-- Game event log defs
EVENT_KILL        = 1
EVENT_SPAWN       = 2
EVENT_GAME        = 3
EVENT_FINISH      = 4
EVENT_SELECTED    = 5
EVENT_BODYFOUND   = 6
EVENT_C4PLANT     = 7
EVENT_C4EXPLODE   = 8
EVENT_CREDITFOUND = 9
EVENT_C4DISARM    = 10

WIN_NONE      = 1
WIN_TRAITOR   = 2
WIN_INNOCENT  = 3
WIN_TIMELIMIT = 4
WIN_MANIAC    = 5

-- Weapon categories, you can only carry one of each
WEAPON_NONE   = 0
WEAPON_MELEE  = 1
WEAPON_PISTOL = 2
WEAPON_HEAVY  = 3
WEAPON_NADE   = 4
WEAPON_CARRY  = 5
WEAPON_EQUIP1 = 6
WEAPON_EQUIP2 = 7
WEAPON_ROLE   = 8

WEAPON_EQUIP = WEAPON_EQUIP1
WEAPON_UNARMED = -1

-- Kill types discerned by last words
KILL_NORMAL  = 0
KILL_SUICIDE = 1
KILL_FALL    = 2
KILL_BURN    = 3

-- Entity types a crowbar might open
OPEN_NO   = 0
OPEN_DOOR = 1
OPEN_ROT  = 2
OPEN_BUT  = 3
OPEN_NOTOGGLE = 4 --movelinear

-- Role groups.
RG_GOOD = 0;
RG_BAD = 1;
RG_FFA = 2;
RG_NONE = 3;


COLOR_WHITE  = Color(255, 255, 255, 255)
COLOR_BLACK  = Color(0, 0, 0, 255)
COLOR_GREEN  = Color(0, 255, 0, 255)
COLOR_DGREEN = Color(0, 100, 0, 255)
COLOR_RED    = Color(255, 0, 0, 255)
COLOR_YELLOW = Color(200, 200, 0, 255)
COLOR_LGRAY  = Color(200, 200, 200, 255)
COLOR_BLUE   = Color(0, 0, 255, 255)
COLOR_NAVY   = Color(0, 0, 100, 255)
COLOR_PINK   = Color(255,0,255, 255)
COLOR_ORANGE = Color(250, 100, 0, 255)
COLOR_OLIVE  = Color(100, 100, 0, 255)