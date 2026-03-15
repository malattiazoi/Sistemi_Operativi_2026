echo "Scegli un animale:"
# PS3="Seleziona un animale (numero): "

select animale in cane gatto pappagallo pesce "Esci"; do
  case $animale in
    cane)
      echo "Hai scelto il cane 🐶"
      break
      ;;
    gatto)
      echo "Hai scelto il gatto 🐈"
      ;;
    pappagallo)
      echo "Hai scelto il pappagallo"
      ;;
    pesce)
      echo "Hai scelto il pesce 🐡"
      ;;
    "Esci")
      echo "Ciao!"
      break
      ;;

  esac
done