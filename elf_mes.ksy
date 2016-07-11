meta:
  id: elf_mes
  application: AI5V / SILV / Elf Messaging System game engine
  endian: le
seq:
  - id: chars_len
    type: u2
  - id: chars
    size: chars_len - 2
    type: chars
  - id: ops
    type: op
    repeat: eos
types:
  chars:
    seq:
      - id: entries
        type: str
        size: 2
        encoding: SJIS
        repeat: eos
  op:
    seq:
      - id: opcode
        type: u1
      - id: next_std_char
        type: u1
        if: opcode >= 0x60 and opcode <= 0x7f
      - id: op4
        type: op4
        if: opcode == 4
      - id: op6
        type: op6
        if: opcode == 6
      - id: op_save_const
        type: op_save_const
        if: opcode == 0xa
      - id: op_save_expr
        type: op_save_expr
        if: opcode == 0xb
      - id: op_make_array
        type: op_make_array
        if: opcode == 0xd
      - id: op_call_proc
        type: op_call_proc
        if: opcode == 0x13
      - id: op_call
        type: op_call
        if: opcode == 0x14
    instances:
      str_char1:
        value: '_root.chars.entries[opcode - 0x80]'
        if: opcode >= 0x80
    enums:
      opcodes:
        0x0: return_0
        0x2: return_2
        0x4: cmd4
        0x6: cmd6
        0xa: save_const
        0xb: save_expr
        0xc: set_base_var
        0xd: make_array
        0xe: make_byte_array
        0xf: if
        0x10: set_dialog_color
        0x11: wait
        0x12: define_proc
        0x13: call_proc
        0x14: call
        0x15: display_num
        0x16: delay
        0x17: clear_screen
        0x18: set_color
        0x19: utility
        0x1a: animate
  op4:
    seq:
      - id: opcode
        type: u1
        enum: opcodes
      - id: param
        if: opcode == opcodes::jump_script or opcode == opcodes::load_image or opcode == opcodes::load_file or opcode == opcodes::palette
        type: param
    enums:
      opcodes:
        0x10: while
        0x11: continue
        0x12: break
        0x13: display_selection
        0x14: initialize_selection
        0x15: mouse
        0x16: palette
        0x17: draw_solid_box
        0x18: draw_inverse_box
        0x19: blit_direct
        0x1a: blit_swapped
        0x1b: blit_masked
        0x1c: load_file
        0x1d: load_image
        0x1e: jump_script
        0x1f: call_script
        0x20: dummy_20
        0x21: manipulate_flag
        0x22: change_slot
        0x23: check_click
        0x24: sound
        0x25: dummy_25
        0x26: field
        0x27: dummy_27
  op6:
    seq:
      - id: str
        type: strz
        encoding: SJIS
        terminator: 6
  op_save_const:
    seq:
      - id: const_idx
        type: const
      - id: elements
        type: expr
        # TODO: elements may be repeated, additional ones can be supplied separated with 0x2
  op_save_expr:
    seq:
      - id: expr_id
        type: expr
      - id: elements
        type: expr
        # TODO: elements may be repeated, additional ones can be supplied separated with 0x2
  op_make_array:
    seq:
      - id: base_idx
        type: u1
      - id: array_idx
        type: expr
      - id: elements
        type: expr
        # TODO: elements may be repeated, additional ones can be supplied separated with 0x2
  op_call_proc:
    seq:
      - id: proc_idx
        type: param
  op_call:
    seq:
      - id: offset
        type: param
  expr:
    seq:
      - id: opcodes
        type: strz
        encoding: ASCII-8BIT
        terminator: 3
        # TODO: proper expression parsing
  param:
    seq:
      - id: code
        type: u1
      - id: str
        type: op6
        if: code == 6
      # TODO: code == 1
      - id: b1
        type: u1
        if: code == 7 or code == 8 or code == 9
      - id: b2
        type: u1
        if: code == 8 or code == 9
      - id: b3
        type: u1
        if: code == 9
  const:
    seq:
      - id: code
        type: u1
      - id: b1
        type: u1
        if: code == 7 or code == 8 or code == 9
      - id: b2
        type: u1
        if: code == 8 or code == 9
      - id: b3
        type: u1
        if: code == 9
