import org.nlogo.api._
import org.nlogo.api.ScalaConversions._
import org.nlogo.core.Syntax
import org.nlogo.core.Syntax.{ NumberType, ListType, BooleanType, StringType }
import scala.reflect.io.File
import scala.io.Source
import scala.util.Random
import scala.collection.mutable.Map
import scala.sys.process._
import org.nlogo.core.PrimitiveReporter
import java.nio.file.{Paths, Files}

class Encrypted extends DefaultClassManager {
  def load(manager: PrimitiveManager) {
    manager.addPrimitive("file-open", new EncryptedFileOpen)
    manager.addPrimitive("file-open-with-passphrase", new EncryptedFileOpenWithPassPhrase)
    manager.addPrimitive("file-close", new EncryptedFileClose)
    manager.addPrimitive("file-at-end?", new EncryptedFileAtEnd)
    manager.addPrimitive("file-read-line", new EncryptedFileRead)
  }
}

object ClearTextStorage {
  var storage = Map[String, ClearText]()
  def put(ct: ClearText) = {
    storage(ct.name) = ct
  }
  def get(name: String): ClearText = {
    storage(name)
  }
  def remove(name: String) = {
    storage -= name
  }
}

class EncryptedFileOpenWithPassPhrase extends Reporter {
  override def getSyntax = Syntax.reporterSyntax(right = List(StringType, StringType), ret = StringType)
  def report(args: Array[Argument], context: Context): AnyRef = {
    val cryptogram = try args(0).getString
    catch {
      case e: LogoException =>
        throw new ExtensionException(e.getMessage)
    }
    val key = try args(1).getString
    catch {
      case e: LogoException =>
        throw new ExtensionException(e.getMessage)
    }
    var ct = new ClearText(cryptogram, key)
    ClearTextStorage.put(ct)
    ct.name
  }
}

class EncryptedFileOpen extends Reporter {
  override def getSyntax = Syntax.reporterSyntax(right = List(StringType), ret = StringType)
  def report(args: Array[Argument], context: Context): AnyRef = {
    val cryptogram = try args(0).getString
    catch {
      case e: LogoException =>
        throw new ExtensionException(e.getMessage)
    }
    var ct = new ClearText(cryptogram)
    ClearTextStorage.put(ct)
    ct.name
  }
}

class EncryptedFileRead extends Reporter {
  override def getSyntax = Syntax.reporterSyntax(right = List(StringType), ret = StringType)
  def report(args: Array[Argument], context: Context): AnyRef = {
    val clearTextName = try args(0).getString
    catch {
      case e: LogoException =>
        throw new ExtensionException(e.getMessage)
    }
    ClearTextStorage.get(clearTextName).next()
  }
  
}

class EncryptedFileClose extends Command {
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

class EncryptedFileAtEnd extends Reporter {
  override def getSyntax = Syntax.reporterSyntax(right = List(StringType), ret = BooleanType)
  def report(args: Array[Argument], context: Context): AnyRef = {
    val clearTextName = try args(0).getString
    catch {
      case e: LogoException =>
        throw new ExtensionException(e.getMessage)
    }
    ClearTextStorage.get(clearTextName).eof().toLogoObject
  }
}

class ClearText () {
                     
  var name: String = new Random(31).toString()
  var pos: Int = 0
  var lines: List[String] = _
  var cryptogram: String = _
  
  check()

  def this(path: String) {
    this()
    cryptogram = path
    decrypt("gpg --decrypt " + cryptogram)   
  }
  
  def this(path: String, key: String)  {
    this() 
    cryptogram = path
    decrypt("gpg --decrypt --passphrase " + key + " " + cryptogram) 
  }
  
  def decrypt(gpg: String) {
    if (!Files.exists(Paths.get(cryptogram))) {
      throw new ExtensionException(cryptogram + " does not exist")
    }
    try  lines = (gpg).!!.toString.split('\n').toList 
    catch {
      case e: Exception =>
        throw new ExtensionException(e.getMessage)
    }
  }
  def check() {
    var ret: Int = 0
    try ret = ("gpg --help").!.toInt
    catch {
      case e: Exception =>
        throw new ExtensionException("gpg has not been installed in your path")
    }
  }

  def next():String  = {
    if (pos > lines.size)
        throw new ExtensionException("read beyond the end of the file at position " + pos)
    var lineNo = pos
    pos = pos + 1
    lines(lineNo)
  }
  
  def eof(): Boolean = {
    if (pos >= lines.size  )
      true
    else
      false
  }
}
