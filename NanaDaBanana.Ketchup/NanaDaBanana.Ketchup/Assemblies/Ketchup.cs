using Verse;

namespace NanaDaBanana.Ketchup.Assemblies
{
    /// <summary>
    /// This class is used to initialize the Ketchup mod.
    /// </summary>
    [StaticConstructorOnStartup]
    public static class Ketchup
    {
        static Ketchup()
        {
            Log.Message("Ketchup initialized.");
        }
    }
}
