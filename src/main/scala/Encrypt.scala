import org.nlogo.api._
import org.nlogo.api.ScalaConversions._
//import scala.collection.JavaConversions._
import scala.collection.JavaConverters._
import org.nlogo.api.Context
import org.nlogo.core.Syntax
import org.nlogo.core.Syntax.{ BooleanType, StringType, RepeatableType }
import org.nlogo.nvm
import scala.io.Source
import scala.util.Random
import scala.collection.mutable.Map
import scala.sys.process._
import org.nlogo.core.PrimitiveReporter
import java.io.File
import System.err.println

class Encrypt extends DefaultClassManager {
  def load(manager: PrimitiveManager) {
    manager.addPrimitive("open", new Open)
    manager.addPrimitive("open-with-passphrase", new OpenWithPassPhrase)
    manager.addPrimitive("close", new Close)
    manager.addPrimitive("at-end?", new AtEnd)
    manager.addPrimitive("read-line", new ReadLine)
    manager.addPrimitive("home", new Home)
    manager.addPrimitive("cmd", new Cmd)
  }
}


class Home extends Command {
  override def getSyntax = Syntax.commandSyntax(right = List(StringType))
  def perform(args: Array[Argument], context: Context) = {
    val cmdLine = try args(0).getString
    catch {
      case e: LogoException =>
        throw new ExtensionException(e.getMessage)
    }
    GPGConfiguration.setHomeDir(cmdLine, context)
  }
}

class Cmd extends Command {
  override def getSyntax = Syntax.commandSyntax(right = List(StringType))
  def perform(args: Array[Argument], context: Context) = {
    val cmdLine = try args(0).getString
    catch {
      case e: LogoException =>
        throw new ExtensionException(e.getMessage)
    }
    GPGConfiguration.set(cmdLine)
  }
}

class Open extends Reporter {
  override def getSyntax = Syntax.reporterSyntax(right = List(StringType) , ret = StringType)
  def report(args: Array[Argument], context: Context): AnyRef = {
    val path = try args(0).getString
    catch {
      case e: LogoException =>
        throw new ExtensionException(e.getMessage)
    }
    val cryptogram = new File(context.workspace.getModelDir + "/" + path)
    if (!cryptogram.exists()) {
      throw new ExtensionException(cryptogram.toString() + " does not exist")
    }
    var ct = new ClearText(cryptogram)
    ClearTextStorage.store(ct)
    // Decrypt it
    ct.open
    ct.name
  }
}

class OpenWithPassPhrase extends Reporter {
  override def getSyntax = Syntax.reporterSyntax(right = List(StringType, StringType) , ret = StringType)
  def report(args: Array[Argument], context: Context): AnyRef = {
    val path = try args(0).getString
    catch {
      case e: LogoException =>
        throw new ExtensionException(e.getMessage)
    }
    val cryptogram = new File(context.workspace.getModelDir + "/" + path)
    if (!cryptogram.exists()) {
      throw new ExtensionException(cryptogram.toString() + " does not exist")
    }
    var ct = new ClearText(cryptogram)
    val passphrase = try args(1).getString
    catch {
      case e: LogoException =>
        throw new ExtensionException(e.getMessage)
    }
    ct.setPassphrase(passphrase)
    ClearTextStorage.store(ct)
    // Decrypt it
    ct.open
    ct.name
  }
}


//class PassPhrase extends Command {
//  override def getSyntax = Syntax.commandSyntax(right = List(StringType, StringType))
//  def perform(args: Array[Argument], context: Context) = {
//    val cryptogram = try args(0).getString
//    catch {
//      case e: LogoException =>
//        throw new ExtensionException(e.getMessage)
//    }
//    val passwd = try args(1).getString
//    catch {
//      case e: LogoException =>
//        throw new ExtensionException(e.getMessage)
//    }
//    ClearTextStorage.retrieve(cryptogram).setPassphrase(passwd)
//  }
//}

//class Open extends Command {
//  override def getSyntax = Syntax.reporterSyntax(right = List(StringType), ret = StringType)
//  def perform(args: Array[Argument], context: Context) = {
//    val cryptogram = try args(0).getString
//    catch {
//      case e: LogoException =>
//        throw new ExtensionException(e.getMessage)
//    }
//    ClearTextStorage.retrieve(cryptogram).open
//  }
//}

class ReadLine extends Reporter {
  override def getSyntax = Syntax.reporterSyntax(right = List(StringType), ret = StringType)
  def report(args: Array[Argument], context: Context): AnyRef = {
    val clearTextName = try args(0).getString
    catch {
      case e: LogoException =>
        throw new ExtensionException(e.getMessage)
    }
    ClearTextStorage.retrieve(clearTextName).next
  }
  
}

class Close extends Command {
  override def getSyntax = Syntax.commandSyntax(right = List(StringType))
  def perform(args: Array[Argument], context: Context) = {
    val clearTextName = try args(0).getString
    catch {
      case e: LogoException =>
        throw new ExtensionException(e.getMessage)
    }

    ClearTextStorage.remove(clearTextName)
  }
}

class AtEnd extends Reporter {
  override def getSyntax = Syntax.reporterSyntax(right = List(StringType), ret = BooleanType)
  def report(args: Array[Argument], context: Context): AnyRef = {
    val clearTextName = try args(0).getString
    catch {
      case e: LogoException =>
        throw new ExtensionException(e.getMessage)
    }
    ClearTextStorage.retrieve(clearTextName).eof.toLogoObject
  }
}

class ClearText (var cryptogram: File) {
                     
  var name: String = new Random(31).toString()
  var pos: Int = 0
  var lines: List[String] = List.empty
  var passphrase: Option[String] = None 
  
  GPGConfiguration.check()

  def open(): Unit = {
    var gpg = GPGConfiguration.commandLine 
    gpg += " --batch --yes --decrypt"
    // One of the differences between Linux and Windows. The character " is not absorbed in Linux
    if (passphrase != None ) {
      gpg += " --passphrase " + passphrase.get
    } else {
      gpg += " --passphrase ''"
    }
    if (GPGConfiguration.homedir != None) {
      gpg += " --homedir " + GPGConfiguration.homedir.get
    }
    gpg += " " + cryptogram.toString()
    Console.println(gpg)
    try lines = (gpg).!!.toString.split('\n').toList
      catch {
        case e: Exception => {
          if (passphrase == "") {
            throw new ExtensionException(e.getMessage + " and gpg command: " + gpg  + " - need password? - try adding \"gpg:passphrase\"")
          }  
          throw new ExtensionException(e.getMessage +  " and gpg command: " + gpg  + " - incorrect password?")
       }
     }
  }
  
  def setPassphrase ( pp : String ) = {
    passphrase = Some(pp)
  }


  def next: String  = {
    if (pos > lines.size)
        throw new ExtensionException("read beyond the end of the file at position " + pos)
    var lineNo = pos
    pos = pos + 1
    lines(lineNo)
  }
  
  def eof: Boolean = {
    if (pos >= lines.size  )
      true
    else
      false
  }

  def close: Unit = {
    name = ""
    pos = 0
    lines  = List.empty
    passphrase  = None
  }
}

object ClearTextStorage {
  var storage = Map[String, ClearText]()
  def store(ct: ClearText) = {
    storage(ct.name) = ct
  }
  def retrieve(name: String): ClearText = {
    storage(name)
  }
  def remove(name: String) = {
    storage(name).close
    storage -= name
  }
}

object GPGConfiguration {
  var commandLine = "gpg"
  var homedir: Option[File] = None
  check()
  def set(cmd: String) = {
    commandLine = cmd
    check()
  }
  def setHomeDir(home: String, context: Context) {
    // for ((k,v) <- System.getProperties.asScala)
    //    Console.println(k + " = "  + v)
    var path = new File(home)
    if (path.exists)
        homedir = Some(path)
    else {
      path = new File(context.workspace.getModelDir + "/" + home)
      if (path.exists) 
        homedir = Some(path)
      else
        throw new ExtensionException(home + " does not seem to exist, becomes " + path)
    }
  }
  def check() ={
    var ver: String = ""
    try ver = (commandLine + " --version").!!.toString
    catch {
      case e: Exception =>
        throw new ExtensionException("gpg has not been installed in your path")
    }
  }
}
