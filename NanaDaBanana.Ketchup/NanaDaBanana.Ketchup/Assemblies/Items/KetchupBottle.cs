using Verse;

namespace NanaDaBanana.Ketchup.Assemblies.Items
{
    public class KetchupBottle : Thing
    {
        public override void ExposeData()
        {
            base.ExposeData();
            Scribe_Values.Look(ref stackCount, "stackCount", 1);
        }

        public override string LabelNoCount
        {
            get
            {
                return "Ketchup Bottle";
            }
        }

        public override string DescriptionDetailed
        {
            get
            {
                return "A bottle of delicious ketchup. Perfect for enhancing the flavor of your meals.";
            }
        }
    }
}
