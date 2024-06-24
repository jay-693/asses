using System;
using System.Drawing;
using App1;

namespace App1
{
    class Global
    {
        public static int glo = 130;

        public void kep()
        {
            glo = glo + 100;
            Console.WriteLine(glo);
        }
    }


    public class MyClass
    {
        public static int MyProperty = 2000 + Global.glo;

        public void MyMethod()
        {
            Console.WriteLine("Inside MyMethod in App1");
        }
    }

    public static class MyStaticClass
    {
        public static string MyStaticProperty { get; set; } = "Hello from App1";

        public static void MyStaticMethod()
        {
            int m = Global.glo + 20;
            Console.WriteLine(m);
            Console.WriteLine("Inside MyStaticMethod in App1");
        }
    }
}

class Temp
{
    public static void Main(string[] args)
    {
        MyClass b1 = new MyClass();
        Global g = new Global();
        Global g1 = new Global();
        App1.MyClass.MyProperty = 33;
        g.kep();
        g.kep();
        g1.kep();
        g1.kep();

    }
}


