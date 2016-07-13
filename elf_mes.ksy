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
      - id: b1
        type: u1
        if: opcode == 7 or opcode == 8 or opcode == 9
      - id: b2
        type: u1
        if: opcode == 8 or opcode == 9
      - id: b3
        type: u1
        if: opcode == 9
      - id: op_set_base_var
        type: op_set_base_var
        if: opcode == 0xc
      - id: op_make_array
        type: op_make_array
        if: opcode == 0xd
    instances:
      str_char1:
        value: '_root.chars.entries[opcode - 0x80]'
#        if: opcode >= 0x80
      simple_const:
        value: opcode - 0x30
#        if: opcode >= 0x30 and opcode <= 0x3f
      base_var:
        value: opcode - 0x40
#        if: opcode >= 0x40 and opcode <= 0x5a
    enums:
      opcodes:
        0x0: end
        0x1: begin
        0x2: comma
        0x3: expr_end
        0x4: cmd4
        0x6: cmd6
        0x7: const_1op
        0x8: const_2op
        0x9: const_3op
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
        0x20: expr_add
        0x21: expr_sub
        0x22: expr_mul
        0x23: expr_div
        0x24: expr_mod
        0x25: expr_or
        0x26: expr_and
        0x27: expr_eq
        0x28: expr_ne
        0x29: expr_gt
        0x2a: expr_lt
        0x2b: expr_mem_word
        0x2c: expr_mem_byte
        0x2d: expr_const_operand
        0x2e: expr_const_stack
        0x2f: expr_random
  op4:
    seq:
      - id: opcode
        type: u1
        enum: opcodes
#      - id: param
#        if: opcode == opcodes::jump_script or opcode == opcodes::load_image or opcode == opcodes::palette
#        type: param
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
  op_set_base_var:
    seq:
      - id: base_idx
        type: u1
  op_make_array:
    seq:
      - id: base_idx
        type: u1
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
