using System.Collections.Generic;
using System.Linq;

namespace NzbDrone.Core.IndexerSearch.Definitions
{
    public class AnimeSeasonSearchCriteria : SearchCriteriaBase
    {
        public int SeasonNumber { get; set; }
        public List<string> BaseSceneTitles { get; set; } = new ();
        public List<string> SeasonSpecificSceneTitles { get; set; } = new ();

        public List<string> QueryTitles
        {
            get
            {
                var queryTitles = new List<string>();

                queryTitles.AddRange(SeasonSpecificSceneTitles);

                foreach (var title in BaseSceneTitles)
                {
                    queryTitles.Add($"{title} S{SeasonNumber}");
                    queryTitles.Add($"{title} S{SeasonNumber:00}");
                }

                return queryTitles
                    .Distinct(System.StringComparer.InvariantCultureIgnoreCase)
                    .ToList();
            }
        }

        public List<string> CleanQueryTitles => QueryTitles
            .Select(GetCleanSceneTitle)
            .Distinct(System.StringComparer.InvariantCultureIgnoreCase)
            .ToList();

        public override string ToString()
        {
            return $"[{Series.Title} : S{SeasonNumber:00}]";
        }
    }
}
