using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using NUnit.Framework.SyntaxHelpers;

namespace Web_App.UnitTests
{
    [TestFixture]
    public class Class1
    {

        [Test]
        public void TestMe()
        {
            Assert.That(1, Is.EqualTo(1));
        }
    }
}
