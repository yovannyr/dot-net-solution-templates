﻿using System;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using EnvDTE;

namespace SolutionFactory.Services
{
    public static class ProjectItemExtensions
    {
        public static bool IsLinkedFile(this ProjectItem projectItem)
        {
            Property isLinkProperty = projectItem.Property("IsLink");

            return isLinkProperty != null && (bool) isLinkProperty.Value;
        }

        public static string Folder(this ProjectItem projectItem)
        {
            Property localpathProperty = projectItem.Property("LocalPath");
            if (localpathProperty != null)
            {
                return localpathProperty.Value.ToString();
            }
            return "";
        }

        public static Property Property(this ProjectItem projectItem, string name)
        {
            return
                projectItem.Properties.OfType<Property>().Where(property => property.Name == name).FirstOrDefault();
        }

        public static bool ShouldReplaceParameters(this ProjectItem projectItem)
        {
            string extension = Path.GetExtension(projectItem.Name).ToLowerInvariant();
            return Equals(extension, ".txt") || Equals(extension, ".cs") || Equals(extension, ".xml") ||
                   Equals(extension, ".aspx") || Equals(extension, ".ascx") || Equals(extension, ".asax") ||
                   Equals(extension, ".config") || Equals(extension, ".master");
        }

        public static bool IsAFile(this ProjectItem projectItem)
        {
            return !projectItem.Kind.Equals("{6BB5F8EF-4483-11D3-8BCF-00C04F8EC28C}");
        }

        public static bool IsAFolder(this ProjectItem projectItem)
        {
            return projectItem.Kind.Equals("{6BB5F8EF-4483-11D3-8BCF-00C04F8EC28C}");
        }
    }

    public class PathUtil
    {
        /// <summary>
        /// Creates a relative path from one file
        /// or folder to another.
        /// </summary>
        /// <param name="fromDirectory">
        /// Contains the directory that defines the
        /// start of the relative path.
        /// </param>
        /// <param name="toPath">
        /// Contains the path that defines the
        /// endpoint of the relative path.
        /// </param>
        /// <returns>
        /// The relative path from the start
        /// directory to the end path.
        /// </returns>
        /// <exception cref="ArgumentNullException"></exception>
        public static string RelativePathTo(
            string fromDirectory, string toPath)
        {
            if (fromDirectory == null)
                throw new ArgumentNullException("fromDirectory");

            if (toPath == null)
                throw new ArgumentNullException("toPath");

            bool isRooted = Path.IsPathRooted(fromDirectory)
                            && Path.IsPathRooted(toPath);

            if (isRooted)
            {
                bool isDifferentRoot = string.Compare(
                                           Path.GetPathRoot(fromDirectory),
                                           Path.GetPathRoot(toPath), true) != 0;

                if (isDifferentRoot)
                    return toPath;
            }

            var relativePath = new StringCollection();
            string[] fromDirectories = fromDirectory.Split(
                Path.DirectorySeparatorChar);

            string[] toDirectories = toPath.Split(
                Path.DirectorySeparatorChar);

            int length = Math.Min(
                fromDirectories.Length,
                toDirectories.Length);

            int lastCommonRoot = -1;

            // find common root
            for (int x = 0; x < length; x++)
            {
                if (string.Compare(fromDirectories[x],
                                   toDirectories[x], true) != 0)
                    break;

                lastCommonRoot = x;
            }
            if (lastCommonRoot == -1)
                return toPath;

            // add relative folders in from path
            for (int x = lastCommonRoot + 1; x < fromDirectories.Length; x++)
                if (fromDirectories[x].Length > 0)
                    relativePath.Add("..");

            // add to folders to path
            for (int x = lastCommonRoot + 1; x < toDirectories.Length; x++)
                relativePath.Add(toDirectories[x]);

            // create relative path
            var relativeParts = new string[relativePath.Count];
            relativePath.CopyTo(relativeParts, 0);

            string newPath = string.Join(
                Path.DirectorySeparatorChar.ToString(),
                relativeParts);

            return newPath;
        }
    }
}