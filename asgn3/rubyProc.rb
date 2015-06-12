# CSCI3180 Principles of Programming Languages

# --- Declaration ---

# I declare that the assignment here submitted is original except for source
# material explicitly acknowledged. I also acknowledge that I am aware of
# University policy and regulations on honesty in academic work, and of the
# disciplinary guidelines and procedures applicable to breaches of such policy
# and regulations, as contained in the website
# http://www.cuhk.edu.hk/policy/academichonesty/

# Assignment 3

class Person
  def initialize(password)
    @password  = password
    @key = 0
    @reserveKey = 0
    @otherDecryptKernel = -1
    @cipherText = ""
  end

  def setKeys(key, reserveKey)
    @key = key
    @reserveKey = reserveKey
  end

  def receive(cipherText, decryptKernel)
    @cipherText = cipherText
    @otherDecryptKernel = decryptKernel
  end

  def encrypt(plainText)
    return "@encryptKernel is not a Proc object!" if @encryptKernel.class != Proc
    return "plainText is not a string!" if plainText.class != String

    @encryptKernel.call plainText
  end

  def decrypt
    return "@otherDecryptKernel is not a Proc object!" if @otherDecryptKernel.class != Proc
    return "@cipherText is not a string!" if @cipherText.class != String

    @otherDecryptKernel.call @cipherText
  end

  def getDecryptKernel
    puts "Please enter the password of #{self.class.name}:"
    password = gets.chomp
    if (password != @password)
      puts "Permission Denied!"
      return -1
    else
      return @myDecryptKernel
    end
  end
end


class Jimmy < Person
  def initialize(password)
    super(password)
    @encryptKernel = Proc.new do | plainText |
      cipherText = ""
      plainText.each_char { | ch |
        newChar = (ch.ord ^ @key).chr
        cipherText += newChar
      }
      cipherText
    end
    @myDecryptKernel = Proc.new do | cipherText |
      plainText = ""
      cipherText.each_char { | ch |
        newChar = (ch.ord ^ @key).chr
        plainText += newChar
      }
      @key = @reserveKey
      plainText
    end
  end
end


class Olivia < Person
  def initialize(password)
    super(password)
    @encryptKernel = Proc.new do | plainText |
      cipherText = ""
      plainText.each_char { | ch |
        newChar = (ch.ord + @key).chr
        cipherText += newChar
      }
      cipherText
    end
    @myDecryptKernel = Proc.new do | cipherText |
      plainText = ""
      cipherText.each_char { | ch |
        newChar = (ch.ord - @key).chr
        plainText += newChar
      }
      @key = @reserveKey
      plainText
    end
  end
end


jimmy = Jimmy.new("jimmy")
olivia = Olivia.new("olivia")
plainText = "I want to cancel the final exam."
jimmy.setKeys(2, 3)
cipherText = jimmy.encrypt(plainText)
puts "Olivia is receiving cipherText and the decryption kernel from Jimmy ..."
olivia.receive(cipherText, jimmy.getDecryptKernel)
puts "Olivia is decrypting the cipherText ..."
puts "For the first time, Olivia gets this result: #{olivia.decrypt}"
puts "For the second time, Olivia gets this result: #{olivia.decrypt}"
puts
plainText = "OK, I will prepare a harder assignment."
olivia.setKeys(4, 5)
cipherText = olivia.encrypt(plainText)
puts "Jimmy is receiving cipherText and decryption kernel from Olivia ..."
jimmy.receive(cipherText, olivia.getDecryptKernel)
puts "Jimmy is decrypting the cipherText ..."
puts "For the first time, Jimmy gets this result: #{jimmy.decrypt}"
puts "For the second time, Jimmy gets this result: #{jimmy.decrypt}"
