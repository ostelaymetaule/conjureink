namespace LandingSite.Web.Tools
{
    using SixLabors.ImageSharp.Processing;
    using SixLabors.ImageSharp.PixelFormats;
    using SixLabors.ImageSharp;

    public class ImageProcessing
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="imagePath">path to the image inside wwwroot (f.ex. content/art) </param>
        /// <param name="imageName"></param>
        /// <param name="forced">re-crop even if the cropped image already exists</param>
        /// <returns></returns>
        public (string thumb, string mid) ResizeAndSave(string imagePath, string imageName, bool forced = false)
        {
            //check if the cropped image already exists
            string rootpath = System.IO.Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", imagePath);
            var dir = new DirectoryInfo(rootpath);
            bool alreadyThumbnailed = dir.EnumerateFiles().Any(f => f.Name == $"thumb_{imageName}");
            bool alreadyMided = dir.EnumerateFiles().Any(f => f.Name == $"mid_{imageName}");

            if (alreadyThumbnailed && alreadyMided && !forced)
            {
                return (Path.Combine(imagePath, $"thumb_{imageName}"), Path.Combine(imagePath, $"mid_{imageName}"));
            }

            using Image image = Image.Load(Path.Combine(rootpath, imageName));
            using Image imageMid = Image.Load(Path.Combine(rootpath, imageName));
            double ratio = image.Width / image.Height;
            if (imageMid.Width > 1500)
            {
                imageMid.Mutate(x => x
                 .Resize(1500, (int)(ratio / 1500)));
            }
            imageMid.Save(Path.Combine(rootpath, $"mid_{imageName}"));

            var maxHeightThumbnail = 300;
            image.Mutate(x => x
                 .Crop(new Rectangle(new Point((int)(image.Width * 0.3), (int)(image.Height * 0.2)), new Size((int)(image.Width * 0.4))))
                 .Resize((int)(maxHeightThumbnail * ratio), maxHeightThumbnail)
                 .Kodachrome());

            image.Save(Path.Combine(rootpath, $"thumb_{imageName}")); // Automatic encoder selected based on extension.
            return (Path.Combine(imagePath, $"thumb_{imageName}"), Path.Combine(imagePath, $"mid_{imageName}")); ;
        }
    }
}
