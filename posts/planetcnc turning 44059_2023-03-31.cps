/**
  Copyright (C) 2012-2023 by Autodesk, Inc.
  All rights reserved.

  PlanetCNC Lathe post processor configuration.

  $Revision: 44059 7d916767d4b2c840da2d4640051619069c45047b $
  $Date: 2023-03-31 22:03:01 $

  FORKID {9AC0E085-C416-4953-B606-882ED3D14F9A}
*/

description = "PlanetCNC Turning 44059 2023-03-31 mod by KMS";
vendor = "PlanetCNC mod by KMS";
vendorUrl = "https://planet-cnc.com/";
longDescription = "Turning post for PlanetCNC. Use Turret 0 for Positional Turret, Turret 101 for QCTP on X- Post, Turret 102 for QCTP on X+ Post, Turret 103 for Gang Tooling on X- Post, Turret 104 for Gang Tooling on X+ Tool Post.";

var outputG43OnSeparateLine = true;

// >>>>> INCLUDED FROM ../common/linuxcnc turning.cps
legal = "Copyright (C) 2012-2023 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 45702;

extension = "ngc";
programNameIsInteger = false;
setCodePage("ascii");

capabilities = CAPABILITY_TURNING;
tolerance = spatial(0.002, MM);

minimumChordLength = spatial(0.25, MM);
minimumCircularRadius = spatial(0.01, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.01);
maximumCircularSweep = toRad(180);
allowHelicalMoves = false;
allowedCircularPlanes = 1 << PLANE_ZX; // allow ZX plane only

// user-defined properties
properties = {
  writeMachine: {
    title      : "Write machine",
    description: "Output the machine settings in the header of the code.",
    group      : "formats",
    type       : "boolean",
    value      : true,    //KMS default
    scope      : "post"
  },
  writeTools: {
    title      : "Write tool list",
    description: "Output a tool list in the header of the code.",
    group      : "formats",
    type       : "boolean",
    value      : true,    //KMS default
    scope      : "post"
  },
  safePositionMethod: {
    title      : "Safe Retracts",
    description: "Select your desired retract option.",
    group      : "homePositions",
    type       : "enum",
    values     : [
      {title:"G28", id:"G28"},
      {title:"G53", id:"G53"}
    ],
    value: "G28",
    scope: "post"
  },
  safePositionStyle: {
    title      : "Safe retract style",
    description: "Select your desired order for the axes to retract.",
    group      : "homePositions",
    type       : "enum",
    values     : [
      {title:"Only X", id:"X"},
      {title:"Only Z", id:"Z"},
      {title:"Both X then Z", id:"XZ"},
      {title:"Both Z then X", id:"ZX"},
      {title:"Both same line", id:"singleLineXZ"}
    ],
    value: "XZ",
    scope: "post"
  },
  showSequenceNumbers: {
    title      : "Use sequence numbers",
    description: "'Yes' outputs sequence numbers on each block, 'Only on tool change' outputs sequence numbers on tool change blocks only, and 'No' disables the output of sequence numbers.",
    group      : "formats",
    type       : "enum",
    values     : [
      {title:"Yes", id:"true"},
      {title:"No", id:"false"},
      {title:"Only on tool change", id:"toolChange"}
    ],
    value: "false", //KMS default
    scope: "post"
  },
  sequenceNumberStart: {
    title      : "Start sequence number",
    description: "The number at which to start the sequence numbers.",
    group      : "formats",
    type       : "integer",
    value      : 10,
    scope      : "post"
  },
  sequenceNumberIncrement: {
    title      : "Sequence number increment",
    description: "The amount by which the sequence number is incremented by in each block.",
    group      : "formats",
    type       : "integer",
    value      : 1,
    scope      : "post"
  },
  optionalStop: {
    title      : "Optional stop",
    description: "Outputs optional stop code during when necessary in the code.",
    group      : "preferences",
    type       : "boolean",
    value      : false, //KMS default
    scope      : "post"
  },
  separateWordsWithSpace: {
    title      : "Separate words with space",
    description: "Adds spaces between words if 'yes' is selected.",
    group      : "formats",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  useRadius: {
    title      : "Radius arcs",
    description: "If yes is selected, arcs are outputted using radius values rather than IJK.",
    group      : "preferences",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  maximumSpindleSpeed: {
    title      : "Max spindle speed",
    description: "Defines the maximum spindle speed allowed by your machines.",
    group      : "configuration",
    type       : "integer",
    range      : [0, 999999999],
    value      : 2000,  //KMS default
    scope      : "post"
  },
  showNotes: {
    title      : "Show notes",
    description: "Writes operation notes as comments in the outputted code.",
    group      : "formats",
    type       : "boolean",
    value      : true,  //KMS default
    scope      : "post"
  },
  useCycles: {
    title      : "Use canned cycles",
    description: "Enable to output canned cycles.",
    group      : "preferences",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  homePositionX: {
    title      : "G53 home position X",
    description: "G53 X-axis home position.",
    group      : "homePositions",
    type       : "number",
    value      : 0,
    scope      : "post"
  },
  homePositionZ: {
    title      : "G53 home position Z",
    description: "G53 Z-axis home position.",
    group      : "homePositions",
    type       : "number",
    value      : 0,
    scope      : "post"
  },
  threadTaperType: {
    title      : "Thread taper type",
    description: "Specifies which ends of the thread get the taper. L0 for no taper, L1 for entry taper, L2 for exit taper, or L3 for both.",
    group      : "preferences",
    type       : "enum",
    values     : [
      {title:"No taper(L0)", id:"L0"},
      {title:"Entry taper(L1)", id:"L1"},
      {title:"Exit taper(L2)", id:"L2"},
      {title:"Entry and exit taper(L3)", id:"L3"}
    ],
    value: "L0",
    scope: "post"
  }
};

// wcs definiton
wcsDefinitions = {
  useZeroOffset: false,
  wcs          : [
    {name:"Standard", format:"G", range:[54, 59]},
    {name:"Extended", format:"G59.", range:[1, 3]}
  ]
};

var singleLineCoolant = false; // specifies to output multiple coolant codes in one line rather than in separate lines
// samples:
// {id: COOLANT_THROUGH_TOOL, on: 88, off: 89}
// {id: COOLANT_THROUGH_TOOL, on: [8, 88], off: [9, 89]}
// {id: COOLANT_THROUGH_TOOL, on: "M88 P3 (myComment)", off: "M89"}
var coolants = [
  {id:COOLANT_FLOOD, on:8},
  {id:COOLANT_MIST, on:7},
  {id:COOLANT_THROUGH_TOOL},
  {id:COOLANT_AIR},
  {id:COOLANT_AIR_THROUGH_TOOL},
  {id:COOLANT_SUCTION},
  {id:COOLANT_FLOOD_MIST},
  {id:COOLANT_FLOOD_THROUGH_TOOL},
  {id:COOLANT_OFF, off:9}
];

var permittedCommentChars = " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,=_-";

var gFormat = createFormat({prefix:"G", decimals:1});
var mFormat = createFormat({prefix:"M", decimals:1});

var spatialFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var xFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true, scale:2}); // diameter mode
var yFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var zFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var rFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true}); // radius
var feedFormat = createFormat({decimals:(unit == MM ? 4 : 5), forceDecimal:true});
var iFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true, scale:1});
var pitchFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var toolFormat = createFormat({decimals:0});
var rpmFormat = createFormat({decimals:0});
var secFormat = createFormat({decimals:3, forceDecimal:true}); // seconds - range 0.001-99999.999
var milliFormat = createFormat({decimals:0}); // milliseconds // range 1-9999
var taperFormat = createFormat({decimals:1, scale:DEG});
var peckFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});

var xOutput; // xOutput is defined in setDirectionX()
var yOutput = createVariable({prefix:"Y"}, yFormat);
var zOutput = createVariable({onchange:function () {retracted[Z] = false;}, prefix:"Z"}, zFormat);
var feedOutput = createVariable({prefix:"F"}, feedFormat);
var pitchOutput = createVariable({prefix:"K", force:true}, pitchFormat);
var sOutput = createVariable({prefix:"S", force:true}, rpmFormat);

// circular output
var kOutput = createReferenceVariable({prefix:"K"}, zFormat);
var iOutput; // iOutput is defined in setDirectionX()

var g92ROutput = createVariable({prefix:"R"}, zFormat); // no scaling
var peckOutput = createVariable({prefix:"Q", force:true}, peckFormat);

var gMotionModal = createModal({}, gFormat); // modal group 1 // G0-G3, ...
var gPlaneModal = createModal({onchange:function () {gMotionModal.reset();}}, gFormat); // modal group 2 // G17-19
var gAbsIncModal = createModal({}, gFormat); // modal group 3 // G90-91
var gFeedModeModal = createModal({}, gFormat); // modal group 5 // G94-95
var gSpindleModeModal = createModal({}, gFormat); // modal group 5 // G96-97
var gUnitModal = createModal({}, gFormat); // modal group 6 // G20-21
var gCycleModal = createModal({}, gFormat); // modal group 9 // G81, ...
var gRetractModal = createModal({}, gFormat); // modal group 10 // G98-99

// fixed settings
var gotSecondarySpindle = false;

var WARNING_WORK_OFFSET = 0;

var QCTP = 0;
var TURRET = 1;
var GANG = 2;

var FRONT = -1;
var REAR = 1;

// collected state
var sequenceNumber;
var currentWorkOffset;
var optionalSection = false;
var forceSpindleSpeed = false;
var tapping = false;
var currentFeedId;
var toolingData;
var previousToolingData;
var retracted = new Array(false, false, false); // specifies that the tool has been retracted to the safe plane

function onPassThrough(text) {  // passtthrough added by KMS
  var commands = String(text).split(",");
  for (text in commands) {
    writeBlock(commands[text]);
  }
}

function getCode(code) {
  switch (code) {
  // case "PART_CATCHER_ON":
  // return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "PART_CATCHER_OFF":
  // return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "TAILSTOCK_ON":
  // return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "TAILSTOCK_OFF":
  // return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "ENGAGE_C_AXIS":
  // machineState.cAxisIsEngaged = true;
  // return cAxisEngageModal.format(SPECIFY YOUR CODE HERE);
  // case "DISENGAGE_C_AXIS":
  // machineState.cAxisIsEngaged = false;
  // return cAxisEngageModal.format(SPECIFY YOUR CODE HERE);
  // case "POLAR_INTERPOLATION_ON":
  // return gPolarModal.format(SPECIFY YOUR CODE HERE);
  // case "POLAR_INTERPOLATION_OFF":
  // return gPolarModal.format(SPECIFY YOUR CODE HERE);
  // case "STOP_LIVE_TOOL":
  // machineState.liveToolIsActive = false;
  // return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "STOP_MAIN_SPINDLE":
  // machineState.mainSpindleIsActive = false;
  // return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "STOP_SUB_SPINDLE":
  // machineState.subSpindleIsActive = false;
  // return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "START_LIVE_TOOL_CW":
  // machineState.liveToolIsActive = true;
  // return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "START_LIVE_TOOL_CCW":
  // machineState.liveToolIsActive = true;
  // return mFormat.format(SPECIFY YOUR CODE HERE);
  case "START_MAIN_SPINDLE_CW":
    // machineState.mainSpindleIsActive = true;
    return mFormat.format(3);
  case "START_MAIN_SPINDLE_CCW":
    // machineState.mainSpindleIsActive = true;
    return mFormat.format(4);
  // case "START_SUB_SPINDLE_CW":
    // machineState.subSpindleIsActive = true;
    // return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "START_SUB_SPINDLE_CCW":
    // machineState.subSpindleIsActive = true;
    // return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "MAIN_SPINDLE_BRAKE_ON":
    // machineState.mainSpindleBrakeIsActive = true;
    // return cAxisBrakeModal.format(SPECIFY YOUR CODE HERE);
  // case "MAIN_SPINDLE_BRAKE_OFF":
    // machineState.mainSpindleBrakeIsActive = false;
    // return cAxisBrakeModal.format(SPECIFY YOUR CODE HERE);
  // case "SUB_SPINDLE_BRAKE_ON":
    // machineState.subSpindleBrakeIsActive = true;
    // return cAxisBrakeModal.format(SPECIFY YOUR CODE HERE);
  // case "SUB_SPINDLE_BRAKE_OFF":
    // machineState.subSpindleBrakeIsActive = false;
    // return cAxisBrakeModal.format(SPECIFY YOUR CODE HERE);
  case "FEED_MODE_UNIT_REV":
    return gFeedModeModal.format(95);
  case "FEED_MODE_UNIT_MIN":
    return gFeedModeModal.format(94);
  case "CONSTANT_SURFACE_SPEED_ON":
    return gSpindleModeModal.format(96);
  case "CONSTANT_SURFACE_SPEED_OFF":
    return gSpindleModeModal.format(97);
  // case "MAINSPINDLE_AIR_BLAST_ON":
  //   return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "MAINSPINDLE_AIR_BLAST_OFF":
  //   return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "SUBSPINDLE_AIR_BLAST_ON":
  //   return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "SUBSPINDLE_AIR_BLAST_OFF":
  //   return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "CLAMP_PRIMARY_CHUCK":
  //   return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "UNCLAMP_PRIMARY_CHUCK":
  //   return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "CLAMP_SECONDARY_CHUCK":
  //   return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "UNCLAMP_SECONDARY_CHUCK":
  //   return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "SPINDLE_SYNCHRONIZATION_ON":
  //   machineState.spindleSynchronizationIsActive = true;
  //   return gSynchronizedSpindleModal.format(SPECIFY YOUR CODE HERE);
  // case "SPINDLE_SYNCHRONIZATION_OFF":
  //   machineState.spindleSynchronizationIsActive = false;
  //   return gSynchronizedSpindleModal.format(SPECIFY YOUR CODE HERE);
  // case "START_CHIP_TRANSPORT":
  //   return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "STOP_CHIP_TRANSPORT":
  //   return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "OPEN_DOOR":
  //   return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "CLOSE_DOOR":
  //   return mFormat.format(SPECIFY YOUR CODE HERE);
  default:
    error(localize("Command " + code + " is not defined."));
    return 0;
  }
}

function isSpindleSpeedDifferent() {
  if (isFirstSection()) {
    return true;
  }
  if (getPreviousSection().getTool().clockwise != tool.clockwise) {
    return true;
  }
  if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
    if ((getPreviousSection().getTool().getSpindleMode() != SPINDLE_CONSTANT_SURFACE_SPEED) ||
        rpmFormat.areDifferent(getPreviousSection().getTool().surfaceSpeed, tool.surfaceSpeed)) {
      return true;
    }
  } else {
    if ((getPreviousSection().getTool().getSpindleMode() != SPINDLE_CONSTANT_SPINDLE_SPEED) ||
        rpmFormat.areDifferent(getPreviousSection().getTool().spindleRPM, spindleSpeed)) {
      return true;
    }
  }
  return false;
}

/**
  Writes the specified block.
*/
function writeBlock() {
  if (getProperty("showSequenceNumbers") == "true") {
    if (optionalSection) {
      var text = formatWords(arguments);
      if (text) {
        writeWords("/", "N" + sequenceNumber, text);
      }
    } else {
      writeWords2("N" + sequenceNumber, arguments);
    }
    sequenceNumber += getProperty("sequenceNumberIncrement");
  } else {
    if (optionalSection) {
      writeWords2("/", arguments);
    } else {
      writeWords(arguments);
    }
  }
}

/**
  Writes the specified optional block.
*/
function writeOptionalBlock() {
  if (getProperty("showSequenceNumbers") == "true") {
    var words = formatWords(arguments);
    if (words) {
      writeWords("/", "N" + sequenceNumber, words);
      sequenceNumber += getProperty("sequenceNumberIncrement");
    }
  } else {
    writeWords2("/", arguments);
  }
}

function formatComment(text) {
  return "(" + filterText(String(text).toUpperCase(), permittedCommentChars).replace(/[()]/g, "") + ")";
}

/**
  Writes the specified block - used for tool changes only.
*/
function writeToolBlock() {
  var show = getProperty("showSequenceNumbers");
  setProperty("showSequenceNumbers", (show == "true" || show == "toolChange") ? "true" : "false");
  writeBlock(arguments);
  setProperty("showSequenceNumbers", show);
}

/**
  Output a comment.
*/
function writeComment(text) {
  writeln(formatComment(text));
}

function onOpen() {
  if (getProperty("useRadius")) {
    maximumCircularSweep = toRad(90); // avoid potential center calculation errors for CNC
  }

  yOutput.disable();

  if (!getProperty("separateWordsWithSpace")) {
    setWordSeparator("");
  }

  sequenceNumber = getProperty("sequenceNumberStart");
  writeln("%");

  if (programName) {
    writeComment(programName);
  }
  if (programComment) {
    writeComment(programComment);
  }

  // dump machine configuration
  var vendor = machineConfiguration.getVendor();
  var model = machineConfiguration.getModel();
  var description = machineConfiguration.getDescription();

  if (getProperty("writeMachine") && (vendor || model || description)) {
    writeComment(localize("Machine"));
    if (vendor) {
      writeComment("  " + localize("vendor") + ": " + vendor);
    }
    if (model) {
      writeComment("  " + localize("model") + ": " + model);
    }
    if (description) {
      writeComment("  " + localize("description") + ": "  + description);
    }
  }

  // dump tool information
  if (getProperty("writeTools")) {
    var zRanges = {};
    if (is3D()) {
      var numberOfSections = getNumberOfSections();
      for (var i = 0; i < numberOfSections; ++i) {
        var section = getSection(i);
        var zRange = section.getGlobalZRange();
        var tool = section.getTool();
        if (zRanges[tool.number]) {
          zRanges[tool.number].expandToRange(zRange);
        } else {
          zRanges[tool.number] = zRange;
        }
      }
    }

    var tools = getToolTable();
    if (tools.getNumberOfTools() > 0) {
      for (var i = 0; i < tools.getNumberOfTools(); ++i) {
        var tool = tools.getTool(i);
        var compensationOffset = tool.isTurningTool() ? tool.compensationOffset : tool.lengthOffset;
        var comment = "T" + toolFormat.format(tool.number) + " " +
            (tool.diameter != 0 ? "D=" + spatialFormat.format(tool.diameter) + " " : "") +
            (tool.isTurningTool() ? localize("NR") + "=" + spatialFormat.format(tool.noseRadius) : localize("CR") + "=" + spatialFormat.format(tool.cornerRadius)) +
            (tool.taperAngle > 0 && (tool.taperAngle < Math.PI) ? " " + localize("TAPER") + "=" + taperFormat.format(tool.taperAngle) + localize("deg") : "") +
            (zRanges[tool.number] ? " - " + localize("ZMIN") + "=" + spatialFormat.format(zRanges[tool.number].getMinimum()) : "") +
             " - " + localize(getToolTypeName(tool.type));
        writeComment(comment);
      }
    }
  }

  writeBlock(gFormat.format(7)); // Diameter mode
  writeBlock(gFormat.format(90), gPlaneModal.format(18)); // Absolute mode and XZ plane

  switch (unit) {
  case IN:
    writeBlock(gUnitModal.format(20));
    break;
  case MM:
    writeBlock(gUnitModal.format(21));
    break;
  }

  if ((getNumberOfSections() > 0) && (getSection(0).workOffset == 0)) {
    for (var i = 0; i < getNumberOfSections(); ++i) {
      if (getSection(i).workOffset > 0) {
        error(localize("Using multiple work offsets is not possible if the initial work offset is 0."));
        return;
      }
    }
  }

  // getProperty("maximumSpindleSpeed") // not supported
  onCommand(COMMAND_START_CHIP_TRANSPORT);
}

function onComment(message) {
  writeComment(message);
}

/** Force output of X, Y, and Z. */
function forceXYZ() {
  xOutput.reset();
  yOutput.reset();
  zOutput.reset();
}

function forceFeed() {
  currentFeedId = undefined;
  feedOutput.reset();
}

/** Force output of X, Y, Z, and F on next output. */
function forceAny() {
  forceXYZ();
  forceFeed();
}

function forceModals() {
  if (arguments.length == 0) { // reset all modal variables listed below
    if (typeof gMotionModal != "undefined") {
      gMotionModal.reset();
    }
    if (typeof gPlaneModal != "undefined") {
      gPlaneModal.reset();
    }
    if (typeof gAbsIncModal != "undefined") {
      gAbsIncModal.reset();
    }
    if (typeof gFeedModeModal != "undefined") {
      gFeedModeModal.reset();
    }
  } else {
    for (var i in arguments) {
      arguments[i].reset(); // only reset the modal variable passed to this function
    }
  }
}

function FeedContext(id, description, feed) {
  this.id = id;
  this.description = description;
  this.feed = feed;
}

function getFeed(f) {
  return feedOutput.format(f); // use feed value
}

function getSpindle() {
  if (getNumberOfSections() == 0) {
    return SPINDLE_PRIMARY;
  }
  if (getCurrentSectionId() < 0) {
    return getSection(getNumberOfSections() - 1).spindle == 0;
  }
  if (currentSection.getType() == TYPE_TURNING) {
    return currentSection.spindle;
  } else {
    if (isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, 1))) {
      return SPINDLE_PRIMARY;
    } else if (isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, -1))) {
      if (!gotSecondarySpindle) {
        error(localize("Secondary spindle is not available."));
      }
      return SPINDLE_SECONDARY;
    } else {
      return SPINDLE_PRIMARY;
    }
  }
}

function ToolingData(_tool) {
  switch (_tool.turret) {
  // Positional Turret
  case 0:
    this.tooling = TURRET;
    this.toolPost = REAR;
    break;
  // QCTP X-
  case 101:
    this.tooling = QCTP;
    this.toolPost = FRONT;
    break;
  // QCTP X+
  case 102:
    this.tooling = QCTP;
    this.toolPost = REAR;
    break;
  // Gang Tooling X-
  case 103:
    this.tooling = GANG;
    this.toolPost = FRONT;
    break;
  // Gang Tooling X+
  case 104:
    this.tooling = GANG;
    this.toolPost = REAR;
    break;
  default:
    error(localize("Turret number must be 0 (main turret), 101 (QCTP X-), 102 (QCTP X+, 103 (gang tooling X-), or 104 (gang tooling X+)."));
    break;
  }
  this.number = _tool.number;
  this.comment = _tool.comment;
  this.toolLength = _tool.bodyLength;
  // HSMWorks returns 0 in tool.bodyLength
  if ((tool.bodyLength == 0) && hasParameter("operation:tool_bodyLength")) {
    this.toolLength = getParameter("operation:tool_bodyLength");
  }
}

function setDirectionX() {
  xFormat.setScale(toolingData.toolPost == FRONT ? Math.abs(xFormat.getScale()) * -1 : Math.abs(xFormat.getScale()));
  iFormat.setScale(toolingData.toolPost == FRONT ? Math.abs(iFormat.getScale()) * -1 : Math.abs(iFormat.getScale()));
  xOutput = createVariable({onchange:function() {retracted[X] = false;}, prefix:"X"}, xFormat);
  iOutput = createReferenceVariable({prefix:"I"}, iFormat);
}

function onSection() {

  if (currentSection.getType() != TYPE_TURNING) {
    if (!hasParameter("operation-strategy") || (getParameter("operation-strategy") != "drill")) {
      if (currentSection.getType() == TYPE_MILLING) {
        error(localize("Milling toolpath is not supported."));
      } else {
        error(localize("Non-turning toolpath is not supported."));
      }
      return;
    }
  }

  var forceSectionRestart = optionalSection && !currentSection.isOptional();
  optionalSection = currentSection.isOptional();

  var turning = (currentSection.getType() == TYPE_TURNING);

  var insertToolCall = forceSectionRestart || isFirstSection() ||
    currentSection.getForceToolChange && currentSection.getForceToolChange() ||
    (tool.number != getPreviousSection().getTool().number) ||
    (tool.compensationOffset != getPreviousSection().getTool().compensationOffset) ||
    (tool.diameterOffset != getPreviousSection().getTool().diameterOffset) ||
    (tool.lengthOffset != getPreviousSection().getTool().lengthOffset);

  var newSpindle = isFirstSection() ||
    (getPreviousSection().spindle != currentSection.spindle);
  var newWorkOffset = isFirstSection() || forceSectionRestart ||
    (getPreviousSection().workOffset != currentSection.workOffset); // work offset changes

  // determine which tooling holder is used
  if (!isFirstSection()) {
    previousToolingData = toolingData;
  }
  toolingData = new ToolingData(tool);
  toolingData.operationComment = "";
  if (hasParameter("operation-comment")) {
    toolingData.operationComment = getParameter("operation-comment");
  }
  toolingData.toolChange = insertToolCall;
  if (isFirstSection()) {
    previousToolingData = toolingData;
  }

  tapping = hasParameter("operation:cycleType") &&
    ((getParameter("operation:cycleType") == "tapping") ||
     (getParameter("operation:cycleType") == "right-tapping") ||
     (getParameter("operation:cycleType") == "left-tapping") ||
     (getParameter("operation:cycleType") == "tapping-with-chip-breaking"));

  setDirectionX();

  if (insertToolCall || newSpindle || newWorkOffset) {
    // retract to safe plane
    if (!isFirstSection() && insertToolCall) {
      onCommand(COMMAND_COOLANT_OFF);
    }
    writeRetract();
    forceXYZ();
  }

  writeln("");

  if (hasParameter("operation-comment")) {
    var comment = getParameter("operation-comment");
    if (comment) {
      writeComment(comment);
    }
  }

  if (getProperty("showNotes") && hasParameter("notes")) {
    var notes = getParameter("notes");
    if (notes) {
      var lines = String(notes).split("\n");
      var r1 = new RegExp("^[\\s]+", "g");
      var r2 = new RegExp("[\\s]+$", "g");
      for (var line in lines) {
        var comment = lines[line].replace(r1, "").replace(r2, "");
        if (comment) {
          writeComment(comment);
        }
      }
    }
  }

  if (!isFirstSection() && getProperty("optionalStop")) {
    onCommand(COMMAND_COOLANT_OFF);
    onCommand(COMMAND_STOP_SPINDLE);
    onCommand(COMMAND_OPTIONAL_STOP);
  }

  if (insertToolCall) {
    forceModals();
    if (tool.number > 999) {  //KMS increase tool count to 999
      warning(localize("Tool number exceeds maximum value."));
    }

    if ((toolingData.tooling == QCTP) || tool.getManualToolChange()) {
      var comment = formatComment(localize("CHANGE TO T") + tool.number + " " + localize("ON") + " " +
        localize((toolingData.toolPost == REAR) ? "REAR TOOL POST" : "FRONT TOOL POST"));
      writeBlock(mFormat.format(0), comment);
    }

    var compensationOffset = tool.isTurningTool() ? tool.compensationOffset : tool.lengthOffset;
    if (compensationOffset > 999) {  //KMS increase tool count to 999
      error(localize("Compensation offset is out of range."));
      return;
    }
    writeToolBlock("T" + toolFormat.format(tool.number), mFormat.format(6), conditional(tool.manualToolChange && !outputG43OnSeparateLine, gFormat.format(43)));
    writeBlock(conditional(tool.manualToolChange && outputG43OnSeparateLine, gFormat.format(43)));
    if (tool.comment) {
      writeComment(tool.comment);
    }

  }

  // Output modal commands here
  writeBlock(gAbsIncModal.format(90), getCode(currentSection.feedMode == FEED_PER_REVOLUTION ? "FEED_MODE_UNIT_REV" : "FEED_MODE_UNIT_MIN"), gPlaneModal.format(18));

  // wcs
  if (insertToolCall) { // force work offset when changing tool
    currentWorkOffset = undefined;
  }

  if (currentSection.workOffset != currentWorkOffset) {
    writeBlock(currentSection.wcs);
    currentWorkOffset = currentSection.workOffset;
  }

  // set coolant after we have positioned at Z
  setCoolant(tool.coolant);

  forceAny();
  gMotionModal.reset();

  // writeBlock(getCode(currentSection.tailstock ? "TAILSTOCK_ON" : "TAILSTOCK_OFF"));

  var initialPosition = getFramePosition(currentSection.getInitialPosition());
  var spindleChanged = forceSpindleSpeed || newSpindle || isSpindleSpeedDifferent();
  if (insertToolCall || spindleChanged) {
    forceSpindleSpeed = false;
    startSpindle(false, true, initialPosition);
  }

  setRotation(currentSection.workPlane);

  if (insertToolCall || tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
    gMotionModal.reset();
    writeBlock(
      gAbsIncModal.format(90),
      gMotionModal.format(0), xOutput.format(initialPosition.x), yOutput.format(initialPosition.y), zOutput.format(initialPosition.z)
    );
    gMotionModal.reset();
  }

  // enable SFM spindle speed
  if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
    startSpindle(false, false);
  }

  if (currentSection.partCatcher) {
    engagePartCatcher(true);
  }
}

function onDwell(seconds) {
  if (seconds > 99999.999) {
    warning(localize("Dwelling time is out of range."));
  }
  _seconds = clamp(0.001, seconds, 99999.999);
  writeBlock(gFormat.format(4), "P" + secFormat.format(_seconds));
}

var pendingRadiusCompensation = -1;

function onRadiusCompensation() {
  pendingRadiusCompensation = radiusCompensation;
}

function onRapid(_x, _y, _z) {
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;
      switch (radiusCompensation) {
      case RADIUS_COMPENSATION_LEFT:
        writeBlock(gMotionModal.format(0), gFormat.format(41), x, y, z);
        break;
      case RADIUS_COMPENSATION_RIGHT:
        writeBlock(gMotionModal.format(0), gFormat.format(42), x, y, z);
        break;
      default:
        writeBlock(gMotionModal.format(0), gFormat.format(40), x, y, z);
      }
    } else {
      writeBlock(gMotionModal.format(0), x, y, z);
    }
    forceFeed();
  }
}

function onLinear(_x, _y, _z, feed) {
  if (isSpeedFeedSynchronizationActive()) {
    var threadPitch = getParameter("operation:threadPitch");
    // lead calculated along the drive line.
    var leadZ = threadPitch * (Vector.diff(getCurrentPosition(), new Vector(_x, _y, _z)).length / (getCurrentPosition().z - _z));
    writeBlock(mFormat.format(50), "P0"); //KMS edit: disable feed overwrite for G33
    writeBlock(gMotionModal.format(33), xOutput.format(_x), yOutput.format(_y), zOutput.format(_z), pitchOutput.format(leadZ));
    writeBlock(mFormat.format(50), "P1"); //KMS edit: enable feed overwrite after G33
    return;
  }

  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var f = getFeed(feed);
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;
      writeBlock(gPlaneModal.format(18));
      switch (radiusCompensation) {
      case RADIUS_COMPENSATION_LEFT:
        writeBlock(gMotionModal.format(1), gFormat.format(41), x, y, z, f);
        break;
      case RADIUS_COMPENSATION_RIGHT:
        writeBlock(gMotionModal.format(1), gFormat.format(42), x, y, z, f);
        break;
      default:
        writeBlock(gMotionModal.format(1), gFormat.format(40), x, y, z, f);
      }
    } else {
      writeBlock(gMotionModal.format(1), x, y, z, f);
    }
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      forceFeed(); // force feed on next line
    } else {
      writeBlock(gMotionModal.format(1), f);
    }
  }
}

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  if (isSpeedFeedSynchronizationActive()) {
    error(localize("Speed-feed synchronization is not supported for circular moves."));
    return;
  }

  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for a circular move."));
    return;
  }

  var start = getCurrentPosition();
  var directionCode = (toolingData.toolPost == REAR) ? (clockwise ? 2 : 3) : (clockwise ? 3 : 2);

  if (isFullCircle()) {
    if (getProperty("useRadius") || isHelical()) { // radius mode does not support full arcs
      linearize(tolerance);
      return;
    }
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(gAbsIncModal.format(90), gMotionModal.format(directionCode), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), getFeed(feed));
      break;
    case PLANE_ZX:
      writeBlock(gAbsIncModal.format(90), gMotionModal.format(directionCode), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    case PLANE_YZ:
      writeBlock(gAbsIncModal.format(90), gMotionModal.format(directionCode), jOutput.format(cy - start.y, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
  } else if (!getProperty("useRadius")) {
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(gAbsIncModal.format(90), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), getFeed(feed));
      break;
    case PLANE_ZX:
      writeBlock(gAbsIncModal.format(90), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    case PLANE_YZ:
      writeBlock(gAbsIncModal.format(90), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), jOutput.format(cy - start.y, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
  } else { // use radius mode
    var r = getCircularRadius();
    if (toDeg(getCircularSweep()) > (180 + 1e-9)) {
      r = -r; // allow up to <360 deg arcs
    }
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(gAbsIncModal.format(90),  gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), getFeed(feed));
      break;
    case PLANE_ZX:
      writeBlock(gAbsIncModal.format(90),  gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), getFeed(feed));
      break;
    case PLANE_YZ:
      writeBlock(gAbsIncModal.format(90),  gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
  }
}

function onCycle() {
}

function getCommonCycle(x, y, z, r) {
  // forceXYZ(); // force xyz on first drill hole of any cycle
  return [xOutput.format(x), yOutput.format(y),
    zOutput.format(z),
    "R" + spatialFormat.format(r)];
}

function onCyclePoint(x, y, z) {
  if (!getProperty("useCycles")) {
    if (tapping) {
      error(localize("Tapping cycles cannot be expanded."));
      return;
    }
    expandCyclePoint(x, y, z);
    return;
  }

  var gPlane;
  if (isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, 1)) ||
      isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, -1))) {
    // writeBlock(gPlaneModal.format(17)); // XY plane
    gPlane = 17;
  } else {
    expandCyclePoint(x, y, z);
    return;
  }

  switch (cycleType) {
  case "thread-turning":
    if (isLastCyclePoint()) {
      if (xFormat.getResultingValue(cycle.incrementalX) != 0) {
        error(localize("Tapered threading cycle is not supported on this control."));
        return;
      }
      // thread height and depth of cut
      var threadHeight = getParameter("operation:threadDepth");
      var firstDepthOfCut = threadHeight / getParameter("operation:numberOfStepdowns");

      var chamferWidth = threadHeight; // 45 degree chamfer
      var id = hasParameter("operation:machineInside") && getParameter("operation:machineInside") == 1;
      var threadClearance = x - cycle.clearance + (id ? -threadHeight : threadHeight);
      var cuttingAngle = 30; // Angle is not stored with tool. toDeg(tool.getTaperAngle());
      if (hasParameter("operation:infeedAngle")) {
        cuttingAngle = getParameter("operation:infeedAngle");
      }

      var threadInfeedMode = "constant";
      if (hasParameter("operation:infeedMode")) {
        threadInfeedMode = getParameter("operation:infeedMode");
      }

      var repeatPass = hasParameter("operation:nullPass") ? getParameter("operation:nullPass") : 0;

      //  Cutting Method:
      //  R1.0 selects constant depth
      //  R2.0  selects constant Area
      //  2>R>1 selects decreasing depth but increasing area
      //  R>2 selects decreaing area

      var threadCuttingMode = 1;
      if (threadInfeedMode == "reduced") {
        threadCuttingMode = 2;
      } else if (threadInfeedMode == "constant") {
        threadCuttingMode = 1;
      } else {
        error(localize("Unsupported Infeed Mode."));
        return;
      }

      //  L- - Specifies which ends of the thread get the taper.
      //  Program L0 for no taper (the default), L1 for entry taper,
      //  L2 for exit taper,
      //  or L3 for both entry and exit tapers.

      writeBlock(
        gMotionModal.format(76),
        "P" + spatialFormat.format(cycle.pitch),
        zOutput.format(z),
        "I" + xFormat.format(threadClearance),
        "J" + xFormat.format(firstDepthOfCut),
        "K" + xFormat.format(threadHeight),
        "R" + spatialFormat.format(threadCuttingMode),
        "Q" + spatialFormat.format(cuttingAngle),
        "H" + spatialFormat.format(repeatPass),
        "E" + spatialFormat.format(chamferWidth),
        getProperty("threadTaperType")
      );
    }
    return;
  }

  if (isFirstCyclePoint()) {
    switch (gPlane) {
    case 17:
      writeBlock(gMotionModal.format(0), zOutput.format(cycle.clearance));
      break;
    case 18:
      writeBlock(gMotionModal.format(0), yOutput.format(cycle.clearance));
      break;
    case 19:
      writeBlock(gMotionModal.format(0), xOutput.format(cycle.clearance));
      break;
    default:
      error(localize("Unsupported drilling orientation."));
      return;
    }

    repositionToCycleClearance(cycle, x, y, z);

    // return to initial Z which is clearance plane and set absolute mode

    var F = cycle.feedrate;
    var P = !cycle.dwell ? 0 : clamp(1, cycle.dwell * 1000, 99999999); // in milliseconds

    switch (cycleType) {
    case "tapping":
    case "left-tapping":
    case "right-tapping":
      F = tool.getThreadPitch();
      writeBlock(
        gFormat.format(33.1),
        zOutput.format(z),
        pitchOutput.format(F)
      );
      break;
    default:
      if (tapping) {
        error(localize("Tapping cycles cannot be expanded."));
        return;
      }
      expandCyclePoint(x, y, z);
    }
  } else {
    if (cycleExpanded) {
      expandCyclePoint(x, y, z);
    } else {
      var _x = xOutput.format(x);
      var _y = yOutput.format(y);
      var _z = zOutput.format(z);
      if (!_x && !_y && !_z) {
        switch (gPlane) {
        case 17: // XY
          xOutput.reset(); // at least one axis is required
          _x = xOutput.format(x);
          break;
        case 18: // ZX
          zOutput.reset(); // at least one axis is required
          _z = zOutput.format(z);
          break;
        case 19: // YZ
          yOutput.reset(); // at least one axis is required
          _y = yOutput.format(y);
          break;
        }
      }
      writeBlock(_x, _y, _z);
    }
  }
}

function onCycleEnd() {
  if (!cycleExpanded) {
    switch (cycleType) {
    case "tapping":
    case "left-tapping":
    case "right-tapping":
      break;
    case "thread-turning":
      forceFeed();
      xOutput.reset();
      zOutput.reset();
      g92ROutput.reset();
      break;
    default:
      writeBlock(gCycleModal.format(80));
    }
  }
}

var currentCoolantMode = COOLANT_OFF;
var coolantOff = undefined;
var forceCoolant = false;

function setCoolant(coolant) {
  var coolantCodes = getCoolantCodes(coolant);
  if (Array.isArray(coolantCodes)) {
    if (singleLineCoolant) {
      writeBlock(coolantCodes.join(getWordSeparator()));
    } else {
      for (var c in coolantCodes) {
        writeBlock(coolantCodes[c]);
      }
    }
    return undefined;
  }
  return coolantCodes;
}

function getCoolantCodes(coolant) {
  var multipleCoolantBlocks = new Array(); // create a formatted array to be passed into the outputted line
  if (!coolants) {
    error(localize("Coolants have not been defined."));
  }
  if (tool.type == TOOL_PROBE) { // avoid coolant output for probing
    coolant = COOLANT_OFF;
  }
  if (coolant == currentCoolantMode && (!forceCoolant || coolant == COOLANT_OFF)) {
    return undefined; // coolant is already active
  }
  if ((coolant != COOLANT_OFF) && (currentCoolantMode != COOLANT_OFF) && (coolantOff != undefined) && !forceCoolant) {
    if (Array.isArray(coolantOff)) {
      for (var i in coolantOff) {
        multipleCoolantBlocks.push(coolantOff[i]);
      }
    } else {
      multipleCoolantBlocks.push(coolantOff);
    }
  }

  forceCoolant = false;

  var m;
  var coolantCodes = {};
  for (var c in coolants) { // find required coolant codes into the coolants array
    if (coolants[c].id == coolant) {
      coolantCodes.on = coolants[c].on;
      if (coolants[c].off != undefined) {
        coolantCodes.off = coolants[c].off;
        break;
      } else {
        for (var i in coolants) {
          if (coolants[i].id == COOLANT_OFF) {
            coolantCodes.off = coolants[i].off;
            break;
          }
        }
      }
    }
  }
  if (coolant == COOLANT_OFF) {
    m = !coolantOff ? coolantCodes.off : coolantOff; // use the default coolant off command when an 'off' value is not specified
  } else {
    coolantOff = coolantCodes.off;
    m = coolantCodes.on;
  }

  if (!m) {
    onUnsupportedCoolant(coolant);
    m = 9;
  } else {
    if (Array.isArray(m)) {
      for (var i in m) {
        multipleCoolantBlocks.push(m[i]);
      }
    } else {
      multipleCoolantBlocks.push(m);
    }
    currentCoolantMode = coolant;
    for (var i in multipleCoolantBlocks) {
      if (typeof multipleCoolantBlocks[i] == "number") {
        multipleCoolantBlocks[i] = mFormat.format(multipleCoolantBlocks[i]);
      }
    }
    return multipleCoolantBlocks; // return the single formatted coolant value
  }
  return undefined;
}

function onSpindleSpeed(spindleSpeed) {
  if (rpmFormat.areDifferent(spindleSpeed, sOutput.getCurrent())) { // avoid redundant output of spindle speed
    startSpindle(false, false, getFramePosition(currentSection.getInitialPosition()), spindleSpeed);
  }
}

function startSpindle(tappingMode, forceRPMMode, initialPosition, rpm) {
  var spindleDir;
  var spindleMode;
  var maxSpeed = "";
  var _spindleSpeed = spindleSpeed;
  if (rpm !== undefined) {
    _spindleSpeed = rpm;
  }
  gSpindleModeModal.reset();

  if ((getSpindle() == SPINDLE_SECONDARY) && !gotSecondarySpindle) {
    error(localize("Secondary spindle is not available."));
    return;
  }

  if (false /*tappingMode*/) {
    spindleDir = getCode("RIGID_TAPPING");
  } else {
    if (getSpindle() == SPINDLE_SECONDARY) {
      spindleDir = tool.clockwise ? getCode("START_SUB_SPINDLE_CW") : getCode("START_SUB_SPINDLE_CCW");
    } else {
      spindleDir = tool.clockwise ? getCode("START_MAIN_SPINDLE_CW") : getCode("START_MAIN_SPINDLE_CCW");
    }
  }

  var maximumSpindleSpeed = (tool.maximumSpindleSpeed > 0) ? Math.min(tool.maximumSpindleSpeed, getProperty("maximumSpindleSpeed")) : getProperty("maximumSpindleSpeed");
  if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
    _spindleSpeed = tool.surfaceSpeed * ((unit == MM) ? 1 / 1000.0 : 1 / 12.0);
    if (forceRPMMode) { // RPM mode is forced until move to initial position
      if (xFormat.getResultingValue(initialPosition.x) == 0) {
        _spindleSpeed = maximumSpindleSpeed;
      } else {
        _spindleSpeed = Math.min((_spindleSpeed * ((unit == MM) ? 1000.0 : 12.0) / (Math.PI * Math.abs(initialPosition.x * 2))), maximumSpindleSpeed);
      }
      spindleMode = getCode("CONSTANT_SURFACE_SPEED_OFF");
    } else {
      maxSpeed = "D" + rpmFormat.format(maximumSpindleSpeed);
      spindleMode = getCode("CONSTANT_SURFACE_SPEED_ON");
    }
  } else {
    spindleMode = getCode("CONSTANT_SURFACE_SPEED_OFF");
  }
  if (getSpindle(true) == SPINDLE_SECONDARY) {
    writeBlock(
      spindleMode,
      maxSpeed,
      sOutput.format(_spindleSpeed),
      spindleDir
    );
  } else {
    writeBlock(
      spindleMode,
      maxSpeed,
      sOutput.format(_spindleSpeed),
      spindleDir
    );
  }
  // wait for spindle here if required
}

function onCommand(command) {
  switch (command) {
  case COMMAND_COOLANT_OFF:
    setCoolant(COOLANT_OFF);
    break;
  case COMMAND_COOLANT_ON:
    setCoolant(COOLANT_FLOOD);
    break;
  case COMMAND_LOCK_MULTI_AXIS:
    break;
  case COMMAND_UNLOCK_MULTI_AXIS:
    break;
  case COMMAND_START_CHIP_TRANSPORT:
    break;
  case COMMAND_STOP_CHIP_TRANSPORT:
    break;
  case COMMAND_BREAK_CONTROL:
    break;
  case COMMAND_TOOL_MEASURE:
    break;
  case COMMAND_ACTIVATE_SPEED_FEED_SYNCHRONIZATION:
    break;
  case COMMAND_DEACTIVATE_SPEED_FEED_SYNCHRONIZATION:
    break;
  case COMMAND_STOP:
    writeBlock(mFormat.format(0));
    forceSpindleSpeed = true;
    forceCoolant = true;
    break;
  case COMMAND_OPTIONAL_STOP:
    writeBlock(mFormat.format(1));
    forceSpindleSpeed = true;
    forceCoolant = true;
    break;
  case COMMAND_END:
    writeBlock(mFormat.format(2));
    break;
  case COMMAND_SPINDLE_CLOCKWISE:
    switch (currentSection.spindle) {
    case SPINDLE_PRIMARY:
      writeBlock(mFormat.format(3));
      break;
    case SPINDLE_SECONDARY:
      error(localize("Secondary spindle not available."));
      break;
    }
    break;
  case COMMAND_SPINDLE_COUNTERCLOCKWISE:
    switch (currentSection.spindle) {
    case SPINDLE_PRIMARY:
      writeBlock(mFormat.format(4));
      break;
    case SPINDLE_SECONDARY:
      error(localize("Secondary spindle not available."));
      break;
    }
    break;
  case COMMAND_START_SPINDLE:
    onCommand(tool.clockwise ? COMMAND_SPINDLE_CLOCKWISE : COMMAND_SPINDLE_COUNTERCLOCKWISE);
    return;
  case COMMAND_STOP_SPINDLE:
    switch (currentSection.spindle) {
    case SPINDLE_PRIMARY:
      writeBlock(mFormat.format(5));
      break;
    case SPINDLE_SECONDARY:
      error(localize("Secondary spindle not available."));
      break;
    }
    break;
  case COMMAND_ORIENTATE_SPINDLE:
    if (getSpindle() == 0) {
      writeBlock(mFormat.format(19)); // use P or R to set angle (optional)
    } else {
      error(localize("Secondary spindle not available."));
    }
    break;
  //case COMMAND_CLAMP: // add support for clamping
  //case COMMAND_UNCLAMP: // add support for clamping
  default:
    onUnsupportedCommand(command);
  }
}

function engagePartCatcher(engage) {
  if (engage) {
    // catch part here
    writeBlock(getCode("PART_CATCHER_ON"), formatComment(localize("PART CATCHER ON")));
  } else {
    onCommand(COMMAND_COOLANT_OFF);
    writeRetract();
    writeBlock(getCode("PART_CATCHER_OFF"), formatComment(localize("PART CATCHER OFF")));
    forceXYZ();
  }
}

function onSectionEnd() {

  // cancel SFM mode to preserve spindle speed
  if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
    startSpindle(false, true, getFramePosition(currentSection.getFinalPosition()));
  }

  if (currentSection.partCatcher) {
    engagePartCatcher(false);
  }

  forceAny();

  if (hasParameter("operation-strategy") && (getParameter("operation-strategy") == "turningPart")) {
    // handle parting here if desired
  }
}

/** Output block to do safe retract and/or move to home position. */
var XZ = 4;
function writeRetract() {
  var words = []; // store all retracted axes in an array
  var singleLineRetract = false;
  var retractAxes = []; // axes to retract
  var method = getProperty("safePositionMethod");

  // define home positions
  var _xHome;
  var _yHome;
  var _zHome;
  if (method == "G28") {
    _xHome = toPreciseUnit(0, MM);
    _yHome = toPreciseUnit(0, MM);
    _zHome = toPreciseUnit(0, MM);
  } else {
    _xHome = machineConfiguration.hasHomePositionX() ? machineConfiguration.getHomePositionX() : getProperty("homePositionX");
    _yHome = machineConfiguration.hasHomePositionY() ? machineConfiguration.getHomePositionY() : toPreciseUnit(0, MM);
    _zHome = machineConfiguration.getRetractPlane() != 0 ? machineConfiguration.getRetractPlane() : getProperty("homePositionZ");
  }

  if (arguments.length > 0) {
    for (var i in arguments) {
      retractAxes.push(arguments[i]);
      singleLineRetract = arguments[i] == XZ ? true : singleLineRetract;
    }
  } else {
    switch (getProperty("safePositionStyle")) {
    case "X":
      retractAxes.push(X);
      break;
    case "Z":
      retractAxes.push(Z);
      break;
    case "XZ":
      retractAxes.push(X, Z);
      break;
    case "ZX":
      retractAxes.push(Z, X);
      break;
    case "singleLineXZ":
      singleLineRetract = true;
      retractAxes.push(X, Z);
      break;
    }
  }

  // format home positions
  for (var i = 0; i < retractAxes.length; ++i) {
    switch (retractAxes[i]) {
    case X:
      words.push((method == "G28" ? "U" : "X") + xFormat.format(_xHome));
      retracted[X] = true;
      xOutput.reset();
      break;
    case Y:
      if (yOutput.isEnabled()) {
        words.push((method == "G28" ? "V" : "Y") + yFormat.format(_yHome));
        yOutput.reset();
      }
      break;
    case Z:
      words.push((method == "G28" ? "W" : "Z") + zFormat.format(_zHome));
      retracted[Z] = true;
      zOutput.reset();
      break;
    case XZ:
      words.push((method == "G28" ? "U" : "X") + xFormat.format(_xHome));
      words.push((method == "G28" ? "W" : "Z") + zFormat.format(_zHome));
      retracted[X] = true;
      retracted[Z] = true;
      xOutput.reset();
      zOutput.reset();
      break;
    default:
      error(localize("Unsupported axis specified for writeRetract()."));
      return;
    }
  }
  for (var i = 0; i < words.length; ++i) {
    switch (method) {
    case "G28":
      writeBlock(gFormat.format(28), singleLineRetract ? words : words[i]);
      break;
    case "G53":
      gMotionModal.reset();
      writeBlock(gFormat.format(53), gMotionModal.format(0), singleLineRetract ? words : words[i]);
      break;
    default:
      error(localize("Unsupported safe position method."));
      return;
    }
    if (singleLineRetract) {
      break;
    }
  }
  singleLineRetract = false; // singleLineRetract reset
}

function onClose() {
  writeln("");

  optionalSection = false;

  onCommand(COMMAND_COOLANT_OFF);
  onCommand(COMMAND_STOP_SPINDLE);

  // we might want to retract in Z before X
  // writeBlock(gFormat.format(30), "Z#5422"); // retract/park

  forceXYZ();
  writeRetract();// change this to writeRetract(XZ) to force retract in XZ at the end of the program as a default

  onImpliedCommand(COMMAND_END);
  onImpliedCommand(COMMAND_STOP_SPINDLE);
  writeBlock(mFormat.format(30)); // stop program, spindle stop, coolant off
  writeln("%");
}

function setProperty(property, value) {
  properties[property].current = value;
}
// <<<<< INCLUDED FROM ../common/linuxcnc turning.cps
