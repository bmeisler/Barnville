package com.evili.worldBuilder.model
{
		public class ItemXMLData
		{
			
			public function ItemXMLData()
			{
			}
			public static function getData():XML{
				var data:XML = <items> 
	<animals>
		<animal name="Cow" price="50" sound="CowSound" numTiles="2" direction="right" layer="world" harvestable="true" forSale="true" growTime="300" prettyName="cow">
			<overlap id="20"/>
		</animal>
		<animal name="CowHarvestable" price="150" sound="CowSound" numTiles="2" direction="right" layer="world" harvestable="true" forSale="false" growTime="5" prettyName="cow">
			<overlap id="20"/>
		</animal>
		<animal name="CowLeft" price="60" sound="CowSound" numTiles="2" direction="left" layer="world" harvestable="true" forSale="true" growTime="60" prettyName="cow">
			<overlap id="1"/>
		</animal>
		<animal name="CowLeftHarvestable" price="150" sound="CowSound" numTiles="2" direction="left" layer="world" harvestable="true" forSale="false" growTime="5" prettyName="cow">
			<overlap id="1"/>
		</animal>
		<animal name="Horse" price="70" sound="HorseSound" numTiles="2" direction="right" layer="world" harvestable="false" forSale="true" prettyName="horse">
			<overlap id="20"/>
		</animal>
		<animal name="HorseLeft" price="70" sound="HorseSound" numTiles="2" direction="left" layer="world" harvestable="false" forSale="true" prettyName="horse">
			<overlap id="1"/>
		</animal>
		<animal name="Sheep" price="40" sound="SheepSound" numTiles="2" direction="right" layer="world" harvestable="true" forSale="true" growTime="225" prettyName="sheep">
			<overlap id="20"/>
		</animal>
		<animal name="SheepHarvestable" price="120" sound="SheepSound" numTiles="2" direction="right" layer="world" harvestable="true" forSale="false" growTime="5" prettyName="sheep">
			<overlap id="20"/>
		</animal>			
		<animal name="SheepLeft" price="40" sound="SheepSound" numTiles="2" direction="left" layer="world" harvestable="true" forSale="true" growTime="45" prettyName="sheep">
			<overlap id="1"/>
		</animal>
		<animal name="SheepLeftHarvestable" price="120" sound="SheepSound" numTiles="2" direction="left" layer="world" harvestable="true" forSale="false" growTime="5" prettyName="sheep">
			<overlap id="1"/>
		</animal>
					
				
		<animal name="Cat" price="10" sound="CatSound" numTiles="1" layer="world" harvestable="false" forSale="true" prettyName="cat"/>
		<animal name="Chicken" price="15" sound="ChickenSound" numTiles="1" layer="world" harvestable="true" forSale="true" growTime="60" prettyName="chicken"/>
		<animal name="ChickenHarvestable" price="45" sound="ChickenSound" numTiles="1" layer="world" harvestable="true" forSale="false" growTime="5" prettyName="chicken"/>
		<animal name="Goat" price="20" sound="GoatSound" numTiles="1" layer="world" harvestable="true" forSale="true" growTime="120" prettyName="goat"/>
		<animal name="GoatHarvestable" price="30" sound="GoatSound" numTiles="1" layer="world" harvestable="true" forSale="false" growTime="5" prettyName="goat"/>
		<animal name="Dog" price="20" sound="DogSound" numTiles="1" layer="world" harvestable="false" forSale="true" prettyName="dog"/>
		<animal name="Pig" price="30" sound="PigSound" numTiles="1" layer="world" harvestable="true" forSale="true" growTime="180" prettyName="pig"/>
		<animal name="PigHarvestable" price="60" sound="PigSound" numTiles="1" layer="world" harvestable="true" forSale="false" growTime="5" prettyName="pig"/>
		<animal name="Rattlesnake" price="60" sound="RattlesnakeSound" numTiles="1" layer="world" harvestable="false" forSale="false" prettyName="rattlesnake"/>
	</animals>
	<tiles>
		<tile name="EarthPatch" price="10" sellPrice="25"  numTiles="1" layer="floor" walkable="true" forSale="false" harvestable="false" prettyName="dirt"/>
		<tile name="TilledEarth" price="10" sellPrice="25" numTiles="1" layer="floor" walkable="true" forSale="false" harvestable="false" prettyName="plowed earth"/>
		<tile name="BabyCorn" price="5"  sellPrice="15" growTime="20" numTiles="1" layer="floor" walkable="true" forSale="true" harvestable="false" prettyName="baby corn"/>
		<tile name="BabyCornWatered" price="5"  sellPrice="15" growTime="20" numTiles="1" layer="floor" walkable="true" forSale="false" harvestable="false" prettyName="watered baby corn"/>
		<tile name="BabyWheat" price="5"  sellPrice="15" growTime="10" numTiles="1" layer="floor" walkable="true" forSale="true" harvestable="false" prettyName="baby wheat"/>
		<tile name="BabyWheatWatered" price="5"  sellPrice="15" growTime="10" numTiles="1" layer="floor" walkable="true" forSale="false" harvestable="false" prettyName="watered baby wheat"/>
		<tile name="GrownCorn" price="5"  sellPrice="15" growTime="20" numTiles="1" layer="floor" walkable="true" forSale="false" harvestable="true" prettyName="corn"/>	
		<tile name="GrownWheat" price="5"  sellPrice="15" growTime="20" numTiles="1" layer="floor" walkable="true" forSale="false" harvestable="true" prettyName="wheat"/>	
		
		<tile name="Haystack" price="2"  numTiles="1" layer="floor" walkable="false" forSale="false" harvestable="true" prettyName="haystack"/>
	</tiles>
	<buildings>
		<building name="Barn" price="200" numTiles="4" layer="world" prettyName="barn">
			<overlap id="-1"/>
			<overlap id="19"/>
			<overlap id="20"/>
		</building>
		<building name="Farmhouse" price="500"  numTiles="4" layer="world"  prettyName="farmhouse">
			<overlap id="-1"/>
			<overlap id="19"/>
			<overlap id="20"/>
		</building>
		<building name="Outhouse" price="100"  numTiles="1" layer="world"  prettyName="outhouse">
		</building>
	</buildings>
	<vehicles>
		<vehicle name="Bulldozer" price="100" numTiles="1" layer="world"/>
	</vehicles>
	<animalActions>
		<action name="HandMove" price="5" numTiles="1" layer="world"/>
		<action name="Love" price="-5"  numTiles="1" layer="world"/>
		<action name="CashRegister" price="2"  numTiles="1" layer="world"/>
		<action name="PickupTruck" price="2"  numTiles="1" layer="world"/>
		<action name="Bulldozer" price="5" numTiles="1" layer="world" sound="Collapse"/>
	</animalActions>
	<cropActions>
		<cropAction name="PickupTruck" price="1"  numTiles="1" layer="world"/>
		<cropAction name="WateringCan" price="1"  numTiles="1" layer="world"/>
		<cropAction name="Tractor" price="1"  numTiles="1" layer="world"/>
		<cropAction name="Manure" price="5"  numTiles="1" layer="floor" walkable="true" forSale="false" sound="Splat"/>
	</cropActions>
</items>
				return data;
			}
		}
}