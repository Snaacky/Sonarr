namespace NzbDrone.Core.Indexers
{
    public interface IRateLimitIndexerSettings
    {
        double RateLimit { get; set; }
    }
}
