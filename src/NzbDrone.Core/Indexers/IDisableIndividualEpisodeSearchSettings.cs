namespace NzbDrone.Core.Indexers
{
    public interface IDisableIndividualEpisodeSearchSettings
    {
        bool DisableIndividualEpisodes { get; set; }
    }
}
