using System;
using System.IO;
using System.Text;
using System.Security.Cryptography;

namespace Harris.Common
{
    public enum SLSHashAlgorithm {SHA1, MD5};
    
    public class HAR_StringEncrypter
    {
        private string m_PassPhrase = "Pas5pr@se";              
        private string m_SeedValue = "s@1tValue";
        private string m_HashAlgorithm = SLSHashAlgorithm.SHA1.ToString();                
        private int    m_PasswordIterations = 2;                
        private string m_InitVector = "@1B2c3D4e5F6g7H8";       
        private int    m_KeySize = 128;                         

        public HAR_StringEncrypter()
        {
        }

        public HAR_StringEncrypter(string passPhrase, string seedVal, SLSHashAlgorithm alg, int pwdIter, string initVec, int keySize)
        {
            m_PassPhrase = passPhrase;
            m_SeedValue = seedVal;
            m_HashAlgorithm = alg.ToString();
            m_PasswordIterations = pwdIter;
            m_InitVector = initVec;
            m_KeySize = keySize;
        }

        public string EncryptString(string valToEncrypt)
        {
            return _Encrypt(valToEncrypt);
        }

        public string DecryptString(string valToDecrypt)
        {
            return _Decrypt(valToDecrypt);
        }

        public string PassPhrase
        {   // Can be any string
            get
            {
                return m_PassPhrase;
            }
            set
            {
                if (0 < value.Length)
                {
                    m_PassPhrase = value;
                }
            }
        }

        public string SeedValue
        {   // Can be any string
            get
            {
                return m_SeedValue;
            }
            set
            {
                if (0 < value.Length)
                {
                    m_SeedValue = value;
                }
            }
        }

        public string InitVector
        {   // must be 16 bytes
            get
            {
                return m_InitVector;
            }
            set
            {
                if (16 == value.Length)
                {
                    m_InitVector = value;
                }
            }
        }

        public int PasswordIterations
        {   // can be any number
            get
            {
                return m_PasswordIterations;
            }
            set
            {
                m_PasswordIterations = value;
            }
        }

        public int KeySize
        {   // can be 128, 192 or 256
            get
            {
                return m_KeySize;
            }
            set
            {
                if ((128 == value) || (192 == value) || (256 == value))
                {
                    m_KeySize = value;
                }
            }
        }         
       
        private string _Encrypt(string plainText)
        {            
            byte[] initVectorBytes = Encoding.ASCII.GetBytes(m_InitVector);
            byte[] seedValueBytes = Encoding.ASCII.GetBytes(m_SeedValue);
            byte[] plainTextBytes = Encoding.UTF8.GetBytes(plainText);

            PasswordDeriveBytes password = new PasswordDeriveBytes(m_PassPhrase, seedValueBytes, m_HashAlgorithm, m_PasswordIterations);
            byte[] keyBytes = password.GetBytes(m_KeySize / 8);
            RijndaelManaged symmetricKey = new RijndaelManaged();
            symmetricKey.Mode = CipherMode.CBC;
            ICryptoTransform encryptor = symmetricKey.CreateEncryptor(keyBytes, initVectorBytes);
            MemoryStream memoryStream = new MemoryStream();
            CryptoStream cryptoStream = new CryptoStream(memoryStream, encryptor, CryptoStreamMode.Write);
            cryptoStream.Write(plainTextBytes, 0, plainTextBytes.Length);
            cryptoStream.FlushFinalBlock();
            byte[] cipherTextBytes = memoryStream.ToArray();
            memoryStream.Close();
            cryptoStream.Close();
            string cipherText = Convert.ToBase64String(cipherTextBytes);

            return cipherText;
        }

        private string _Decrypt(string cipherText)
        {            
            byte[] initVectorBytes = Encoding.ASCII.GetBytes(m_InitVector);
            byte[] saltValueBytes = Encoding.ASCII.GetBytes(m_SeedValue);
            byte[] cipherTextBytes = Convert.FromBase64String(cipherText);
            PasswordDeriveBytes password = new PasswordDeriveBytes(m_PassPhrase, saltValueBytes, m_HashAlgorithm, m_PasswordIterations);
            byte[] keyBytes = password.GetBytes(m_KeySize / 8);
            RijndaelManaged symmetricKey = new RijndaelManaged();
            symmetricKey.Mode = CipherMode.CBC;
            ICryptoTransform decryptor = symmetricKey.CreateDecryptor(keyBytes, initVectorBytes);
            MemoryStream memoryStream = new MemoryStream(cipherTextBytes);
            CryptoStream cryptoStream = new CryptoStream(memoryStream, decryptor, CryptoStreamMode.Read);
            byte[] plainTextBytes = new byte[cipherTextBytes.Length];
            int decryptedByteCount = cryptoStream.Read(plainTextBytes, 0, plainTextBytes.Length);
            memoryStream.Close();
            cryptoStream.Close();
            string plainText = Encoding.UTF8.GetString(plainTextBytes, 0, decryptedByteCount);
  
            return plainText;
        }
    }    
}