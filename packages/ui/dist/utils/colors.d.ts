export declare const serviceColors: {
    readonly blue: {
        readonly primary: "bg-blue-600 hover:bg-blue-700";
        readonly light: "bg-blue-100 text-blue-800";
        readonly text: "text-blue-600";
        readonly border: "border-blue-200";
    };
    readonly green: {
        readonly primary: "bg-green-600 hover:bg-green-700";
        readonly light: "bg-green-100 text-green-800";
        readonly text: "text-green-600";
        readonly border: "border-green-200";
    };
    readonly purple: {
        readonly primary: "bg-purple-600 hover:bg-purple-700";
        readonly light: "bg-purple-100 text-purple-800";
        readonly text: "text-purple-600";
        readonly border: "border-purple-200";
    };
    readonly red: {
        readonly primary: "bg-red-600 hover:bg-red-700";
        readonly light: "bg-red-100 text-red-800";
        readonly text: "text-red-600";
        readonly border: "border-red-200";
    };
};
export type ServiceColor = keyof typeof serviceColors;
export declare function getServiceColorClasses(color: ServiceColor): {
    readonly primary: "bg-blue-600 hover:bg-blue-700";
    readonly light: "bg-blue-100 text-blue-800";
    readonly text: "text-blue-600";
    readonly border: "border-blue-200";
} | {
    readonly primary: "bg-green-600 hover:bg-green-700";
    readonly light: "bg-green-100 text-green-800";
    readonly text: "text-green-600";
    readonly border: "border-green-200";
} | {
    readonly primary: "bg-purple-600 hover:bg-purple-700";
    readonly light: "bg-purple-100 text-purple-800";
    readonly text: "text-purple-600";
    readonly border: "border-purple-200";
} | {
    readonly primary: "bg-red-600 hover:bg-red-700";
    readonly light: "bg-red-100 text-red-800";
    readonly text: "text-red-600";
    readonly border: "border-red-200";
};
//# sourceMappingURL=colors.d.ts.map