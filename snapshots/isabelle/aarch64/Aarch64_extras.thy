chapter \<open>Generated by Lem from ../aarch64_extras.lem.\<close>

theory "Aarch64_extras" 

imports 
 	 Main
	 "Lem_pervasives_extra" 
	 "Sail2_instr_kinds" 
	 "Sail2_values" 
	 "Sail2_operators_mwords" 
	 "Sail2_prompt_monad" 
	 "Sail2_prompt" 

begin 

(*open import Pervasives_extra*)
(*open import Sail2_instr_kinds*)
(*open import Sail2_values*)
(*open import Sail2_operators_mwords*)
(*open import Sail2_prompt_monad*)
(*open import Sail2_prompt*)

(*type ty512*)
(*type ty1024*)
(*type ty2048*)

definition hexchar_to_bool_list  :: " char \<Rightarrow>((bool)list)option "  where 
     " hexchar_to_bool_list c = (
  if c = (CHR ''0'') then      Some ([False,False,False,False])
  else if c = (CHR ''1'') then Some ([False,False,False,True ])
  else if c = (CHR ''2'') then Some ([False,False,True, False])
  else if c = (CHR ''3'') then Some ([False,False,True, True ])
  else if c = (CHR ''4'') then Some ([False,True, False,False])
  else if c = (CHR ''5'') then Some ([False,True, False,True ])
  else if c = (CHR ''6'') then Some ([False,True, True, False])
  else if c = (CHR ''7'') then Some ([False,True, True, True ])
  else if c = (CHR ''8'') then Some ([True, False,False,False])
  else if c = (CHR ''9'') then Some ([True, False,False,True ])
  else if c = (CHR ''A'') then Some ([True, False,True, False])
  else if c = (CHR ''a'') then Some ([True, False,True, False])
  else if c = (CHR ''B'') then Some ([True, False,True, True ])
  else if c = (CHR ''b'') then Some ([True, False,True, True ])
  else if c = (CHR ''C'') then Some ([True, True, False,False])
  else if c = (CHR ''c'') then Some ([True, True, False,False])
  else if c = (CHR ''D'') then Some ([True, True, False,True ])
  else if c = (CHR ''d'') then Some ([True, True, False,True ])
  else if c = (CHR ''E'') then Some ([True, True, True, False])
  else if c = (CHR ''e'') then Some ([True, True, True, False])
  else if c = (CHR ''F'') then Some ([True, True, True, True ])
  else if c = (CHR ''f'') then Some ([True, True, True, True ])
  else None )"


definition hexstring_to_bools  :: " string \<Rightarrow>((bool)list)option "  where 
     " hexstring_to_bools s = (
  (case  ( s) of
      z # x # hs =>
       (let str = (if ((z = (CHR ''0'')) \<and> (x = (CHR ''x''))) then hs else z # (x # hs)) in
       map_option List.concat (just_list (List.map hexchar_to_bool_list str)))
    | _ => None
  ))"


(*val hex_slice : forall 'rv 'n 'e. Size 'n => string -> integer -> integer -> monad 'rv (mword 'n) 'e*)
definition hex_slice  :: " string \<Rightarrow> int \<Rightarrow> int \<Rightarrow>('rv,(('n::len)Word.word),'e)monad "  where 
     " hex_slice v len lo = (
  maybe_fail (''hex_slice'') (hexstring_to_bools v) \<bind> (\<lambda> bs . 
   (let hi = ((len + lo) -( 1 :: int)) in
   (let bs = (ext_list False (len + lo) bs) in
   return (Word.of_bl (subrange_list False bs hi lo))))))"


(*val BigEndianReverse : forall 'rv 'n 'e. Size 'n => mword 'n -> monad 'rv (mword 'n) 'e*)
definition BigEndianReverse  :: "('n::len)Word.word \<Rightarrow>('rv,(('n::len)Word.word),'e)monad "  where 
     " BigEndianReverse w = ( return (reverse_endianness w))"


(* Use constants for some undefined values for now *)
definition undefined_string  :: " unit \<Rightarrow>('b,(string),'a)monad "  where 
     " undefined_string _ = ( return (''''))"

definition undefined_unit  :: " unit \<Rightarrow>('b,(unit),'a)monad "  where 
     " undefined_unit _ = ( return ()  )"

definition undefined_int  :: " unit \<Rightarrow>('b,(int),'a)monad "  where 
     " undefined_int _ = ( return (( 0 :: int)::ii))"

(*val undefined_vector : forall 'rv 'a 'e. integer -> 'a -> monad 'rv (list 'a) 'e*)
definition undefined_vector  :: " int \<Rightarrow> 'a \<Rightarrow>('rv,('a list),'e)monad "  where 
     " undefined_vector len u = ( return (repeat [u] len))"

(*val undefined_bitvector : forall 'rv 'a 'e. Size 'a => integer -> monad 'rv (mword 'a) 'e*)
definition undefined_bitvector  :: " int \<Rightarrow>('rv,(('a::len)Word.word),'e)monad "  where 
     " undefined_bitvector len = ( return (Word.of_bl (repeat [False] len)))"

(*val undefined_bits : forall 'rv 'a 'e. Size 'a => integer -> monad 'rv (mword 'a) 'e*)
definition undefined_bits  :: " int \<Rightarrow>('rv,(('a::len)Word.word),'e)monad "  where 
     " undefined_bits = ( undefined_bitvector )"

definition undefined_bit  :: " unit \<Rightarrow>('b,(bitU),'a)monad "  where 
     " undefined_bit _ = ( return B0 )"

definition undefined_real  :: " unit \<Rightarrow>('b,(real),'a)monad "  where 
     " undefined_real _ = ( return (realFromFrac(( 0 :: int))(( 1 :: int))))"

definition undefined_range  :: " 'a \<Rightarrow> 'd \<Rightarrow>('c,'a,'b)monad "  where 
     " undefined_range i j = ( return i )"

definition undefined_atom  :: " 'a \<Rightarrow>('c,'a,'b)monad "  where 
     " undefined_atom i = ( return i )"

definition undefined_nat  :: " unit \<Rightarrow>('b,(int),'a)monad "  where 
     " undefined_nat _ = ( return (( 0 :: int)::ii))"


(*val write_ram : forall 'rv 'a 'b 'c 'e. Size 'b, Size 'c =>
  integer -> integer -> mword 'a -> mword 'b -> mword 'c -> monad 'rv unit 'e*)
definition write_ram  :: " int \<Rightarrow> int \<Rightarrow>('a::len)Word.word \<Rightarrow>('b::len)Word.word \<Rightarrow>('c::len)Word.word \<Rightarrow>('rv,(unit),'e)monad "  where 
     " write_ram addrsize size1 hexRAM address value1 = (
  (write_mem_ea instance_Sail2_values_Bitvector_Machine_word_mword_dict Write_plain address size1 \<then>
  write_mem_val instance_Sail2_values_Bitvector_Machine_word_mword_dict value1) \<bind>  (\<lambda>x .  (case  x of _ => return ()  )) )"


(*val read_ram : forall 'rv 'a 'b 'c 'e. Size 'b, Size 'c =>
  integer -> integer -> mword 'a -> mword 'b -> monad 'rv (mword 'c) 'e*)
definition read_ram  :: " int \<Rightarrow> int \<Rightarrow>('a::len)Word.word \<Rightarrow>('b::len)Word.word \<Rightarrow>('rv,(('c::len)Word.word),'e)monad "  where 
     " read_ram addrsize size1 hexRAM address = (
  (*let _ = prerr_endline (Reading  ^ (stringFromInteger size) ^  bytes from address  ^ (stringFromInteger (unsigned address))) in*)
  read_mem instance_Sail2_values_Bitvector_Machine_word_mword_dict instance_Sail2_values_Bitvector_Machine_word_mword_dict Read_plain address size1 )"


(*val elf_entry : unit -> integer*)
definition elf_entry  :: " unit \<Rightarrow> int "  where 
     " elf_entry _ = (( 0 :: int))"

end
