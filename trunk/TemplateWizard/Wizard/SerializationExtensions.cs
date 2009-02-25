using System;
using System.IO;
using System.Xml.Serialization;

namespace Scaffolding.Exporter
{
    public static class SerializationExtensions
    {
        public static void Serialize(this object o, string filename)
        {
            Type t = o.GetType();
            if (t.IsSerializable)
            {
                var serializer = new XmlSerializer(t);
                using (TextWriter tw = new StreamWriter(filename))
                {
                    serializer.Serialize(tw, o);
                    tw.Close();
                }
            }
            else
            {
                throw new InvalidOperationException(string.Format("Objects of type {0} are not serializable.", t.Name));
            }
        }
    }
}